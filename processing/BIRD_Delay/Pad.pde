class Pad {
  final int xPos;
  final int yPos;

  LED p1;
  LED pwr;
  LED p2;

  boolean onPad1;
  boolean onPad2;
  boolean onPwr;

  final int LED_OFFSET_X = 100;
  final int LED_OFFSET_Y = 20;

  Pad() {
    xPos = 300;
    yPos = 425;

    p1 = new LED(
      xPos + (LED_OFFSET_X * 1),
      yPos + LED_OFFSET_Y,
      color(255,0,0)
    );
    pwr = new LED(
      xPos + (LED_OFFSET_X * 2),
      yPos + LED_OFFSET_Y,
      color(0,255,0)
    );
    p2 = new LED(
      xPos + (LED_OFFSET_X * 3),
      yPos + LED_OFFSET_Y,
      color(255,255,0)
    );

    onPad1 = false;
    onPad2 = false;
    onPwr = false;
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
