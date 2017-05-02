String original = "The solution was found just shortly before going to sleep using the pillow instead of a table. The plaintext is recognized as the book of Daniel from the Bible, and the codeword for this stage is";

String simonSingh = "BT JPX RMLX PCUV AMLX ICVJP IBTWXVR CI M LMT’R PMTN, MTN YVCJX CDXV MWMBTRJ JPX AMTNGXRJBAH UQCT JPX QGMRJXV CI JPX YMGG CI JPX HBTW’R QMGMAX; MTN JPX HBTW RMY JPX QMVJ CI JPX PMTN JPMJ YVCJX. JPXT JPX HBTW’R ACUTJXTMTAX YMR APMTWXN, MTN PBR JPCUWPJR JVCUFGXN PBL, RC JPMJ JPX SCBTJR CI PBR GCBTR YXVX GCCRXN, MTN PBR HTXXR RLCJX CTX MWMBTRJ MTCJPXV. JPX HBTW AVBXN MGCUN JC FVBTW BT JPX MRJVCGCWXVR, JPX APMGNXMTR, MTN JPX RCCJPRMEXVR. MTN JPX HBTW RQMHX, MTN RMBN JC JPX YBRX LXT CI FMFEGCT, YPCRCXDXV RPMGG VXMN JPBR YVBJBTW, MTN RPCY LX JPX BTJXVQVXJMJBCT JPXVXCI, RPMGG FX AGCJPXN YBJP RAM";

int[] simonCipher = {2, 8, 14, 21, 24, 1, 11, 10, 5, 19, 25, 12, 0, 3, 9, 7, 15, 18, 16, 13, 20, 17, 6, 4, 22, 23};

int[] alphabet = new int[26];

int populationSize = 50;

float mutationRate = 0.01;
DNA test, test2;
DNA alphabetArranged;
DNA[] cipher = new DNA[populationSize];
int rng;
void setup() {
  rng = int(random(1000));
  size(displayWidth, displayHeight);
  for (int i = 0; i < alphabet.length; i++) {
    alphabet[i] = i;
  }

  textSize(11);

  original = original.toLowerCase();
  simonSingh = simonSingh.toLowerCase();

  println(rearrange(simonSingh, simonCipher));
  //test = new DNA(createCipher(alphabet));
  test2 = new DNA(simonCipher);
  test = new DNA(simonCipher);
  // alphabetArranged = new DNA();
  alphabetArranged = new DNA(simonCipher);

  for (int i = 0; i < cipher.length; i++) {
    cipher[i] = new DNA(createCipher(alphabet));
    cipher[i].setDecryptedString(cipher[i].decrypt(simonSingh));
    cipher[i].calculateFitness();
  }

  test2.setDecryptedString(test2.decrypt(simonSingh));
  test2.calculateFitness();

  //println(test2.codeString);
  //println(test2.decryptedString);
  //println(test2.letterCountOnDecryptedString);
  //println(test2.fitness);


  test.setDecryptedString(test.decrypt(simonSingh));
  test.calculateFitness();
  //println(test.codeString);
  //println(test.decryptedString);
  //println(test.letterCountOnDecryptedString);
  //println(test.fitness);

  println("-----------");
  alphabetArranged.setDecryptedString(alphabetArranged.decrypt(simonSingh));
  alphabetArranged.calculateFitness();
  //println(alphabetArranged.codeString);
  //println(alphabetArranged.decryptedString);
  //println(alphabetArranged.letterCountOnDecryptedString);
  //println(alphabetArranged.fitness);
  update();
}

void draw() {
  update();
}

void update() {
  background(0);
  fill(255);
  pushMatrix();
  translate(25, 25);
  alphabetArranged.displayCode(0, 0);
  alphabetArranged.displayDecryptedString(0, 10);
  alphabetArranged.displayFitness(175, 0);
  translate(0, 25);

  //test.updateCipher(createCipher(alphabet));
  //test.setDecryptedString(test.decrypt(simonSingh));
  //test.calculateFitness();

  test.displayCode(0, 0);
  test.displayDecryptedString(0, 10);
  test.displayFitness(175, 0);



  translate(0, 25);
  for (int i = 0; i < cipher.length; i++) {
    translate(0, 25);

    cipher[i].displayCode(0, 0);
    cipher[i].displayDecryptedString(0, 10);
    cipher[i].displayFitness(175, 0);
  }

  popMatrix();



  // commence the mating rituals
  ArrayList<DNA> matingPool = new ArrayList<DNA>();

  for (int i = 0; i < cipher.length; i++) {
    int n = int(cipher[i].fitness*100);
    for (int  j = 0; j < n; j++) {
      matingPool.add(cipher[i]);
    }
  }


  for (int i = 0; i < cipher.length; i++) {

    int a = int(random(matingPool.size()));
    int b = int(random(matingPool.size()));

    DNA partnerA = matingPool.get(a);
    // println(a + " 0= " + partnerA.codeString);
    DNA partnerB = matingPool.get(b);
    // println(b + " 1= " + partnerB.codeString);

    DNA child = partnerA.crossover(partnerB);
    //child.mutate(mutationRate); // this could be included in the previous step/process

    cipher[i] = child;
  }

  println("ave: " + averageFitness());
  println("high: " + highestFitnessObtained);

  framecount++;

  //if (framecount<0) framecount = 0;
}

int framecount=0;

void mouseClicked() {
  update();
}

String bestCipherFound = "";

float highestFitnessObtained = 0;
float averageFitness() {
  float sum = 0;
  for (int i = 0; i < populationSize; i++) {
    sum += cipher[i].fitness;
    println(cipher[5].fitness);
    if (highestFitnessObtained < cipher[i].fitness) {
      highestFitnessObtained = cipher[i].fitness;
      saveFrame("screenshots/"+rng+"/GA-codebook2-"+framecount+ ".png");
      test = cipher[i];
    }
  }
  float avFitness =  (sum/float(populationSize));

  println(sum + " / " + float(populationSize) + " = " + avFitness);
  return avFitness;
}


int[] avoidDuplicates(int[] d) {

  boolean doItAgain = false;
  int[] temp = d;
  int[] count = new int[temp.length];

  println("we got this array ");
  println(d);
  int theExcessValue = -1;
  for (int i = 0; i < temp.length; i++) {
    count[temp[i]]++;
    if (count[temp[i]]>1) {
      theExcessValue = temp[i];
    }
    if (count[temp[i]]>4){ // arbitrary number
      return createCipher(alphabet);
    }
  }
  println("freq count:");
  println(count);
  println("there are too many " + theExcessValue + "s");

  int theScarceValue = -1;
  for (int i = 0; i < temp.length; i++) {
    if (count[i]<1) {
      theScarceValue = i;
      doItAgain = true;
      break;
    }
  }

  println("there are too few " + theScarceValue + "s");


  println("...");
  println("Fixing this");
  for (int i = 0; i < temp.length; i++) {
    if (temp[i] == theExcessValue) {
      temp[i] = theScarceValue;
      break;
    }
  }


  if (doItAgain)
    temp = avoidDuplicates(temp);

  return temp;
  //if (shouldWeDoThisAgain) avoidDuplicates
}