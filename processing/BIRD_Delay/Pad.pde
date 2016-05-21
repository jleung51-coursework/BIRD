class Pad {
  int xPos;
  int yPos;
  LED p1;
  LED pwr;
  LED p2;
  boolean onPad1 = false;
  boolean onPad2 = false;
  boolean onPwr = false;

  Pad() {
    xPos = 300;
    yPos = 425;
    p1 = new LED(xPos+100, yPos+20, color(255,0,0));
    pwr = new LED(xPos+200, yPos+20, color(0,255,0));
    p2 = new LED(xPos+300, yPos+20, color(255,255,0));
  }

  void update(boolean pad1, boolean pwr, boolean pad2) {
    onPad1 = pad1;
    onPwr = pwr;
    onPad2 = pad2;
  }

  void drawMe() {
    stroke(10);
    rect(xPos, yPos, 400, 300);

    fill(color(200, 200, 200));
    if(onPwr){
      fill(color(0, 255, 0));
    }
    rect(xPos+185, yPos+50, 30, 30);
    p1.drawMe();
    pwr.drawMe();
    p2.drawMe();

    fill(color(200, 200, 200));
    if(onPad1){
      fill(color(255, 0, 0));
    }

    rect(xPos+30, yPos+130, 140, 140);
    fill(color(200, 200, 200));
    if(onPad2){
      fill(color(255, 255, 0));
    }
    rect(xPos+230, yPos+130, 140, 140);
  }

}
