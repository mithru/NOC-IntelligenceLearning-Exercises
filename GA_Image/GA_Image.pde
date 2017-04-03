/* 
 based heavily on code form Daniel Shiffman's Nature of code book
 http://natureofcode.com/book/chapter-9-the-evolution-of-code/
 */

float mutationRate = 0.1;
int totalPopulation = 912;

int count = 0; // generation count

DNA test;

DNA[] population = new DNA[totalPopulation];

float highestFitnessObtained = 0;

//ArrayList <DNA> matingPool;
//ArrayList<DNA> matingPool = new ArrayList<DNA>();

int imageW = 16; // num of pixels
int tileW = 2; // pixels per tile
int sizeOfEachImage;

PImage targetImg;
color[] target = new color[imageW*imageW];

//String filename = "mithru.png";
//String filename = "a.png";
String filename = "wwf-panda.png";
//String filename = "mario.png";

void setup() {
  size(displayWidth, displayHeight);
  background(255);

  sizeOfEachImage = imageW * tileW;

  targetImg = loadImage(filename);
  image(targetImg, width-sizeOfEachImage, 0, sizeOfEachImage, sizeOfEachImage);
  target = getPixelValues(targetImg, imageW, imageW);

  for (int i = 0; i < population.length; i++) {
    population[i] = new DNA();
  }

  test = new DNA(target);
  //test.displayImage(50, 0, 3);
  //test.fitness();
}

void draw() {
  background(255);
  fill(0);
  text("target : ", width-sizeOfEachImage*3, 20);
  text("best : ", width-sizeOfEachImage*3, sizeOfEachImage+20);
  image(targetImg, width-sizeOfEachImage, 0, sizeOfEachImage, sizeOfEachImage);
  test.displayImage(width-sizeOfEachImage, sizeOfEachImage+1, 2);

  for (int i = 0; i < population.length; i++) {
    population[i].fitness();
    population[i].displayImage((i/(height/sizeOfEachImage))*(sizeOfEachImage+1), (i%(height/sizeOfEachImage))*(sizeOfEachImage+1), tileW);
  }
  ArrayList<DNA> matingPool = new ArrayList<DNA>();

  //TODO - monte carlo method
  for (int i = 0; i < population.length; i++) {
    int n = int(population[i].fitness*100);  
    for (int  j = 0; j < n; j++) {
      matingPool.add(population[i]);
    }
  }

  println("Generation = " + count);
  println("total pool size = " + matingPool.size());
  println("average fitness = " + averageFitness());
  fill(0, 200);
  rect(0, 0, 220, 160);
  fill(255);
  text("Poputation = " + totalPopulation, 20, 20);
  text("Mutation Rate = " + mutationRate, 20, 40);
  text("Generation = " + count, 20, 60);
  text("total pool size = " + matingPool.size(), 20, 80);
  text("average fitness = " + averageFitness(), 20, 100);
  text("highest fitness seen = " + highestFitnessObtained, 20, 120);
  text("Time in seconds = " + millis()/1000, 20, 140);
  // println(int(random(int(255)/int(20)))*20);

  for (int i = 0; i < population.length; i++) {
    int a = int(random(matingPool.size()));
    int b = int(random(matingPool.size()));

    DNA partnerA = matingPool.get(a);
    DNA partnerB = matingPool.get(b);

    DNA child = partnerA.crossover(partnerB);
    //child.mutate(mutationRate); // this could be included in the previous step/process

    population[i] = child;
  }
  //test.displayImage(30);
  
  
  if(count % 50 == 0){
    saveFrame(""+count+filename);
  }
  count++;
  

}


// this is still buggy but low priority (it's good enough)
color[] getPixelValues(PImage img, int numOfPixelsAlongX, int numOfPixelsAlongY) {
  color[] values = new color[numOfPixelsAlongX*numOfPixelsAlongY]; 

  for (int i = 0; i < numOfPixelsAlongX; i ++) {
    for (int j = 0; j < numOfPixelsAlongY; j ++) {
      values[(j*numOfPixelsAlongX)+i] = img.get(int((i+0.25)*(img.width/numOfPixelsAlongX)), int((j+0.25)*(img.height/numOfPixelsAlongY)));
    }
  }

  return values;
}

float averageFitness() {
  float sum = 0;
  for (int i = 0; i < population.length; i++) {
    sum+= population[i].fitness;
    if (highestFitnessObtained < population[i].fitness) {
      highestFitnessObtained = population[i].fitness;
      test = population[i];
    }
  }
  return (sum/population.length);
}

void keyReleased() {
  switch(key) {
  case 's':
    saveFrame("###"+filename);
    println("screenshot taken");
    break;
  }
}