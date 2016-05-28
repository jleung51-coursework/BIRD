class Pad {
  final int xPos;
  final int yPos;

  LED p1;
  LED pwr;
  LED p2;

  boolean onPad1;
  boolean onPad2;
  boolean onPwr;

  final int OUTLINE_SIZE = 10;

  final int LED_OFFSET_X = 100;
  final int LED_OFFSET_Y = 20;

  final int WIDTH = 400;
  final int HEIGHT = 300;

  final int POWER_BUTTON_OFFSET_X = 185;
  final int POWER_BUTTON_OFFSET_Y = 50;
  final int POWER_BUTTON_SIZE = 30;

  final int PAD1_OFFSET_X = 30;
  final int PAD2_OFFSET_X = 230;
  final int PAD_OFFSET_Y = 130;
  final int PAD_SIZE = 140;

  final color COLOR_WHITE = color(255);
  final color COLOR_GREY_LIGHT = color(200);
  final color COLOR_GREEN = color(0, 255, 0);
  final color COLOR_RED = color(255, 0, 0);
  final color COLOR_YELLOW = color(255, 255, 0);

  Pad() {
    xPos = 300;
    yPos = 425;

    p1 = new LED(
      xPos + (LED_OFFSET_X * 1),
      yPos + LED_OFFSET_Y,
      COLOR_RED
    );
    pwr = new LED(
      xPos + (LED_OFFSET_X * 2),
      yPos + LED_OFFSET_Y,
      COLOR_GREEN
    );
    p2 = new LED(
      xPos + (LED_OFFSET_X * 3),
      yPos + LED_OFFSET_Y,
      COLOR_YELLOW
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
    stroke(OUTLINE_SIZE);

    // Entire pad
    fill(COLOR_WHITE);
    rect(xPos, yPos, WIDTH, HEIGHT);

    // Power button
    fill(COLOR_GREY_DARK);
    if(onPwr){
      fill(COLOR_GREEN);
    }
    rect(
      xPos + POWER_BUTTON_OFFSET_X,
      yPos + POWER_BUTTON_OFFSET_Y,
      POWER_BUTTON_SIZE, POWER_BUTTON_SIZE
    );

    // LEDs
    p1.drawMe();
    pwr.drawMe();
    p2.drawMe();

    // Pad 1
    if(onPad1){
      fill(COLOR_RED);
    }
    else {
      fill(COLOR_GREY_LIGHT);
    }
    rect(
      xPos + PAD1_OFFSET_X,
      yPos + PAD_OFFSET_Y,
      PAD_SIZE, PAD_SIZE
    );

    // Pad 2
    if(onPad2){
      fill(COLOR_YELLOW);
    }
    else {
      fill(COLOR_GREY_LIGHT);
    }
    rect(
      xPos + PAD2_OFFSET_X,
      yPos + PAD_OFFSET_Y,
      PAD_SIZE, PAD_SIZE
    );
  }

}
