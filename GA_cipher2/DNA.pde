class DNA {
  int[] code = new int[26];
  int[] letterCountOnDecryptedString = new int[26];
  float fitness;
  float differenceTolerance; // if the letter is within this percentage value of frequency of the ideal, give it max score.

  String codeString, decryptedString;  

  DNA() {
    codeString="";
    decryptedString="";
    differenceTolerance = 2;
    fitness = 0;

    for (int i = 0; i < this.letterCountOnDecryptedString.length; i++) {
      this.letterCountOnDecryptedString[i] = 0;
    }

    for (int i = 0; i < this.code.length; i++) {
      this.code[i] = i;
    }

    this.setCodeString();

    //this.code = createCipher(alphabet);
  }

  DNA(int[] ciph) {

    codeString="";
    decryptedString="";
    for (int i = 0; i < this.letterCountOnDecryptedString.length; i++) {
      this.letterCountOnDecryptedString[i] = 0;
    }
    differenceTolerance = 2;
    codeString = "";
    fitness = 0;
    this.code = ciph;
    this.setCodeString();
  }

  void setCodeString() {
    codeString = "";
    for (int i = 0; i < this.code.length; i++) {
      codeString = codeString + char(code[i]+asciiShift);
    }
  }

  void updateCipher(int[] ciph) {
    for (int i = 0; i < this.letterCountOnDecryptedString.length; i++) {
      this.letterCountOnDecryptedString[i] = 0;
    }
    this.code = ciph;
    this.fitness = 0;
    this.setCodeString();
  }

  void displayCode(int x, int y) {
    text(this.codeString, x, y);
  }
  void displayDecryptedString(int x, int y) {
    text(this.decryptedString, x, y);
  }
  void displayFitness(int x, int y) {
    text(this.fitness, x, y);
  }

  void setDecryptedString(String s) {
    this.decryptedString = s;
  }

  String decrypt(String encodedString) {
    String decodedString = rearrange(encodedString, this.code); // rearrange applies the cipher to the string

    return decodedString;
  }

  void calculateFitness() {
    int count = 0;
    int score = 0;

    // calculate letter frequency chart
    for (int i = 0; i < decryptedString.length(); i++) {
      if (decryptedString.charAt(i) - asciiShift >= 0 && decryptedString.charAt(i) - asciiShift < alphabet.length) {
        count++;
        this.letterCountOnDecryptedString[decryptedString.charAt(i) - asciiShift]++;
      }
    }

    // cycle through ideal frequency chart and calculate difference
    // println("character" + "\t" + "letterC" + "\t" + "% " + "\t"+  "difference" + "\t" + "newD" + "\t" + "multiplier");

    for (int i = 0; i < alphabet.length; i++) {
      float occurance = letterCountOnDecryptedString[i]/float(count);
      float difference = abs((occurance*100) - letterFrequencyPercentage[i]);
      float newD = difference;
      float multiplier;
      if (difference < differenceTolerance) {
        newD = 0;
        multiplier = 1;
      } else {
        multiplier = 1 - pow((difference/100), 0.005);
      } 
      score += multiplier;
      // println(char(i+asciiShift) + "\t" + letterCountOnDecryptedString[i]+ "\t" + nf(occurance, 2, 2) + "\t"+ nf(difference, 2, 2) + "\t" + nf(newD, 2, 2) + "\t" + multiplier);
    }
    this.fitness = score/float(alphabet.length);
    //  println("Fitness =\t" + this.fitness);
  }

  DNA crossover(DNA partner) {
    DNA child;

    boolean partnerGeneSent;
    int parentsSimilarityScore = 0;

    for (int i = 0; i < this.code.length; i++) {
      if (this.codeString.charAt(0) == partner.codeString.charAt(0)) {
        parentsSimilarityScore++;
      }
    }    
    //println("me " + codeString.charAt(0));
    //println("partner " + partner.codeString.charAt(0));

    if (parentsSimilarityScore > 20) { // arbitrary number here :(
      child = new DNA(createCipher(alphabet));
      println("creating new random child");
    } else {
      child = new DNA(); 
      for (int i = 0; i < this.code.length; i++) {
        if (random(1)<0.5) {
          //  print("me \t");
          //child.code[i] = this.cipherString.charAt(i)-asciiShift;
          child.code[i] = int(this.codeString.charAt(i)-asciiShift);
          partnerGeneSent = false;
        } else {       
          //   print("partner\t");
          // child.code[i] = partner.cipherString.charAt(i)-asciiShift; 
          child.code[i] = int(partner.codeString.charAt(i)-asciiShift);
          partnerGeneSent = true;
        }


       //avoiding duplicate letters
        for (int j = i-1; j >=0; j--) {
          if (child.code[i] == child.code[j]) {

            // this part needs fixing TODO
            child.code[i] = partnerGeneSent?codeString.charAt(i)-asciiShift:partner.codeString.charAt(i)-asciiShift;
            if (codeString.charAt(i)-asciiShift == partner.codeString.charAt(i)-asciiShift) {
              child.code[i] = -1;
              //testCounter++;
              //int temp = child.cipher[i];
              //child.cipher[i] = child.cipher[i-1];
              //child.cipher[i - 1] = temp;
            }
          }
        }

        //mutate (swap letters) here to avoid extra loop
        //if (random(1)< mutationRate*pow((parentsSimilarityScore/this.code.length), 1)) // if parents are similar, then mutate more
        if (random(1)< mutationRate) // if parents are similar, then mutate more
        {

          println("creating mutation");
          int index1 = int(random(code.length));
          int index2 = int(random(code.length));
          int temp =  child.code[index1];
          child.code[index1] = child.code[index2];
          child.code[index2] = temp;
        }
      }
    }
    //child.code = avoidDuplicates(child.code);
    child.setCodeString();
    child.setDecryptedString(child.decrypt(simonSingh));
    child.calculateFitness();
    return child;
  }
}