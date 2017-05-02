
int[] createCipher(int[] alph) {
  int scrambled[] = new int[26];
  scrambled = alph;
  int l = scrambled.length;
  for (int i = l; i > 0; i--) {
    int pos = int(random(l*10)%l);
    int tmp = scrambled[i-1];
    scrambled[i-1] = scrambled[pos];
    scrambled[pos] = tmp;
    //   println(char(i-1+asciiShift) + " --> " + char(scrambled[i-1]+asciiShift));
  }
  return scrambled;
}


String rearrange(String text, int[] cipher) {

  // println("rearranging");
  String encryptedString = "";
  for (int i = 0; i < text.length(); i++) {
    if (text.charAt(i)-asciiShift >= 0 && text.charAt(i)-asciiShift < cipher.length) {
      //  println(i + " : " + (text.charAt(i)-asciiShift) + " : " + text.charAt(i) + " --> " + char((cipher[text.charAt(i)-asciiShift])+asciiShift));
      encryptedString = encryptedString + char((cipher[text.charAt(i)-asciiShift])+asciiShift);
    } else {
      encryptedString = encryptedString + " ";
    }
  }

  return encryptedString;
}