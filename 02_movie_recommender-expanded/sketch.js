// Daniel Shiffman
// Nature of Code: Intelligence and Learning
// https://github.com/shiffman/NOC-S17-2-Intelligence-Learning

// Data set and code based on
// https://github.com/arthur-e/Programming-Collective-Intelligence/blob/master/chapter2/recommendations.py

// All the data from the JSON file
var ratingsData;

var movieData;
// Movie ratings by person
var ratings;
// A list of all the movies
var allMovies;

var movieCount = 0;

var dropdowns = [];

var movieLimit = 100; // to make our program run faster

// Preload all the data
function preload() {
  ratingsData = loadJSON('data/ratings.json', loadMovieData);
}

function loadMovieData(){
  movieData = loadJSON('data/movies.json', restructureData);
}

var data;
function restructureData(){

    console.log("restructureData");
    movieCount=Object.keys(movieData).length;
    ratingsCount = Object.keys(ratingsData).length;

    console.log("movieCount = " + movieCount);
    console.log("ratingsCount = " + ratingsCount);
    data = new Object();

    //create "movies" key
    data.movies = [];
    for (var i = 0; i < movieCount; i++){
      data.movies.push(movieData[i].title);
    }

    //create "ratings" key
    data.ratings = new Object();
    var currentUser = 0;
    var currentMovie = 0;
    var currentMovieName = "";
    // var currentUserRatings;
    console.log("restructureData2");

    var ratingsCap = 2000; // for my sanity
    for(var i = 0; i < ratingsCap; i++){
    // for(var i = 0; i < ratingsCount; i++){

      //currentMovieName = getMovieNameFromId(ratingsData[i].movieId);
      currentMovie = ratingsData[i].movieId.toString();
      if(currentUser !== ratingsData[i].userId){
        currentUser = ratingsData[i].userId; // update userId.

      //  var currentUserRatings = newObject(); // create new empty object

        data.ratings[currentUser.toString()] = new Object; // set the previous user's ratings
        data.ratings[currentUser.toString()][currentMovie] = ratingsData[i].rating; // aaaaaaaaarrrggghh

      } else {
        data.ratings[currentUser.toString()][currentMovie] = ratingsData[i].rating; // aaaaaaaaarrrggghh
      }

    //console.log(currentUser + ": " + currentMovie + " - " + currentMovieName);
    }
    generatePage();
}

function getMovieNameFromId(theId){ //binary search wasn't implemented properly. so I resorted to this. this needs to be looked into
  var currNum = theId;
/*
  //console.log("currNum = " + currNum);
  for(var index = currNum-1; index >= 0; index--){
    //console.log(theId + " : " + movieData[index].movieId);
    if(theId === movieData[index].movieId){
      return movieData[index].title;
    }
  }
*/
  if(theId === movieData[currNum-1].movieId){
    return movieData[index].title;
  } else return theId.toString();

/*
    if(currNum === movieData[currNum-1].movieId){
      console.log(currNum + ", " + movieData[currNum-1].title);
      return movieData[currNum-1].title;
    } else {
      currNum += 1;
      return getMovieNameFromId(currNum);
    }
*/
}

function generatePage(){


  console.log("movieCount = " + movieCount);

  for (var i = 0; i < movieLimit; i++) { // would ideally use movieCount
    // Make a DIV for each movie
    var div = createDiv(movieData[i].title + ' ');
    div.style('padding','4px 0px');
    div.parent('#interface');
    // Create a dropdown menu for each movie
    var dropdown = createSelect();
    dropdown.option('not seen');
    // 1 to 5 stars
    for (var stars = 1; stars < 6; stars++) {
      dropdown.option(stars);
    }
    dropdown.parent(div);
    // Connect the dropdown with the movie title
    dropdown.movie = movieData[i];
    dropdowns.push(dropdown);
  }

  // This is a submit button
  var submit = createButton('submit');
  submit.parent('#interface');
  submit.style('margin','4px 0px');
  submit.style('padding','4px');

  // When the button is clicked
  submit.mousePressed(function() {
    // Make a new user
    var user = {};
    // Attach all the ratings
    for (var i = 0; i < dropdowns.length; i++) {
      var value = dropdowns[i].value();
      if (value != 'not seen') {
        var movie = dropdowns[i].movie;
        // Make sure they are numbers!
        user[movie] = Number(value);
      }
    }
    // Put it in the data
    data.ratings['user'] = user;
    // Call the get Recommendations function!
    // We can use either "euclidean" distance or "pearson" score
    getRecommendations('user', euclidean);
  });

}

function setup() {
  noCanvas();
  // Get the bits out of the data we want
  // ratings = data.ratings;
  ratings = data.ratings;
  allMovies = data.movies;
}

// A function to get recommendations
function getRecommendations(person, similarity) {

  // Clear the div
  select("#results").html('');

  // This will be the object to store recommendations
  var recommendations = {};

  // Let's get all the people in the database
  var people = Object.keys(ratings);

  // For every person
  for (var i = 0; i < people.length; i++) {
    var other = people[i];

    // Don't use yourself for a recommendation!
    if (other != person) {
      // Get the similarity score
      var sim = similarity(person, other);
      // If it's 0 or less ignore!
      if (sim <= 0) continue;
      // What movies did the other person rate?
      var movies = Object.keys(ratings[other]);
      for (var j = 0; j < movies.length; j++) {
        var movie = movies[j];
        // As long as I have not already rated the movie!
        if (!ratings[person][movie]) {
          // Have we not seen this movie before with someone else?
          if (recommendations[movie] == undefined) {
            recommendations[movie] = {
              total: 0,
              simSum: 0,
              ranking: 0
            }
          }
          // Add up the other persons rating weighted by similarity
          recommendations[movie].total += ratings[other][movie] * sim;
          // Add up all similarity scores
          recommendations[movie].simSum += sim;
        }
      }
    }
  }

  // Ok, now we can calculate the estimated star rating for each movie
  var movies = Object.keys(recommendations);
  for (var i = 0; i < movies.length; i++) {
    var movie = movies[i];
    // Total score divided by total similarity score
    recommendations[movie].ranking = recommendations[movie].total / recommendations[movie].simSum;
  }



  // Sore movies by ranking
  movies.sort(byRanking);
  function byRanking(a, b) {
    return recommendations[b].ranking - recommendations[a].ranking;
  }

  // Display everything in sorted order
  for (var i = 0; i < movies.length; i++) {
    var movie = movies[i];
    var stars = recommendations[movie].ranking;
    var rec = createP(movie + ' ' + nf(stars,1,1) + '⭐');
    rec.parent('#results');
  }
}
