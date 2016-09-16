/*
 * This Processing class implements an object symbolizing the pressure "pad"
 * sensor system for the BIRD system.
 *
 */

class Pad {

  private final int xPos;
  private final int yPos;

  private LED p1;
  private LED pwr;
  private LED p2;

  private boolean onPad1;
  private boolean onPad2;
  private boolean onPwr;

  private static final int OUTLINE_SIZE = 10;

  private static final int LED_OFFSET_X = 100;
  private static final int LED_OFFSET_Y = 20;

  private static final int WIDTH = 400;
  private static final int HEIGHT = 300;

  private static final int POWER_BUTTON_OFFSET_X = 185;
  private static final int POWER_BUTTON_OFFSET_Y = 50;
  private static final int POWER_BUTTON_SIZE = 30;

  private static final int PAD1_OFFSET_X = 30;
  private static final int PAD2_OFFSET_X = 230;
  private static final int PAD_OFFSET_Y = 130;
  private static final int PAD_SIZE = 140;

  private final color COLOR_WHITE = color(255);
  private final color COLOR_GREY_LIGHT = color(200);
  private final color COLOR_GREEN = color(0, 255, 0);
  private final color COLOR_RED = color(255, 0, 0);
  private final color COLOR_YELLOW = color(255, 255, 0);

  public Pad() {
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

  public void update(boolean pad1, boolean pwr, boolean pad2) {
    onPad1 = pad1;
    onPwr = pwr;
    onPad2 = pad2;
  }

  public void drawMe() {
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
