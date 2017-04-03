class DNA {
  // we're using 16x16 pixel images = 256 pixels stored in a one-dimensional array
  // the "genotype" here would be color information of each tile
  color[] tiles = new color[256]; 
  float fitness;

  int tolerance = 1;

  DNA() {
    for (int i = 0; i < tiles.length; i++) {
      //color
      //tiles[i] =  color(int(random(255)), int(random(255)), int(random(255)));

      //greyscale
      tiles[i] =  color(int(random(int(255)/int(tolerance)))*tolerance);
    }
  }

  // using the below constructor for tests
  DNA(color[] preset) {
    this.tiles = preset;
  }

  void fitness() {
    tolerance = int(20*(1 - averageFitness()));
    int score = 0;
    if (tiles.length != target.length) {
      println("ERROR - target and current specimen does not match");
    }

    //comparing only red for now
    for (int i = 0; i < tiles.length; i++) {
      float difference = abs(red(target[i]) - red(tiles[i]));
      float multiplier;
      if (difference < tolerance) { // arbitrary tolerance to increase the odds
        multiplier = 1;
      } else {
        multiplier = 1 - pow((difference-tolerance)/256, 2); // made the curve exponential
      }
      score += multiplier;
    }

    fitness = float(score)/target.length;
    // println(fitness);
  }

  // go thru all tiles ("genes")
  // "flip a coin" to decide which parent's tile ("gene") should be replicated   
  DNA crossover(DNA partner) {
    DNA child = new DNA();
    
    int parentsSimilarityScore = 0; // how related are the parents?
    for (int i = 0; i < tiles.length; i++) {
      if(tiles[i] == partner.tiles[i]){
        parentsSimilarityScore++;
      }
    }
    for (int i = 0; i < tiles.length; i++) {
      if (random(1)<0.5)
        child.tiles[i] = tiles[i];
      else
        child.tiles[i] = partner.tiles[i];

      //mutate here to avoid extra loop
      if (random(1)< mutationRate*pow((parentsSimilarityScore/tiles.length),2)) // if parents are similar, then mutate more
        tiles[i] = color(int(random(int(255)/int(tolerance)))*tolerance);
    }
    return child;
  }

  //void mutate(float mutationRate) {
  //  for (int i = 0; i < tiles.length; i++) {
  //    if (random(1)< mutationRate)
  //      tiles[i] = color(int(random(int(255)/int(tolerance)))*tolerance);
  //  }
  //}

  // converts 1 dimensional pixel array into 2D square of tiles (Phenotype)
  void displayImage(int x, int y, int size) { 
    noStroke();
    for (int i = 0; i < tiles.length; i++) {
      fill(tiles[i]);
      rect(x+(i%sqrt(tiles.length))*size, y+(int(i/sqrt(tiles.length)))*size, size, size);
    }
  }
}