/*
 * This Processing class implements an object symbolizing the car "box" for
 * the BIRD system.
 *
 */

class Box {

  private LED p1;
  private LED pwr;
  private LED p2;

  private final int X_POSITION;
  private final int Y_POSITION;

  private static final int CIRCLE_DIAMETER = 150;
  private static final int POWER_BUTTON_SIZE = 15;
  private static final int PROX_SENSOR_WIDTH = 40;
  private static final int PROX_SENSOR_HEIGHT = 15;

  private final color COLOR_WHITE = color(255);
  private final color COLOR_GREY_LIGHT = color(200);
  private final color COLOR_RED = color(255, 0, 0);
  private final color COLOR_GREEN = color(0, 255, 0);
  private final color COLOR_YELLOW = color(255, 255, 0);

  public Box(int x, int y) {
    X_POSITION = x;
    Y_POSITION = y;

    final int LED1_x = X_POSITION + 4;
    final int LED1_y = Y_POSITION + 78;

    final int LEDpwr_x = X_POSITION + 40;
    final int LEDpwr_y = Y_POSITION + 68;

    final int LED2_x = X_POSITION + 66;
    final int LED2_y = Y_POSITION + 42;

    p1 = new LED(LED1_x, LED1_y, COLOR_RED);
    pwr = new LED(LEDpwr_x, LEDpwr_y, COLOR_GREEN);
    p2 = new LED(LED2_x, LED2_y, COLOR_YELLOW);
  }

  public void update(){
  }

  public void drawMe() {
    pushMatrix();
    translate(X_POSITION, Y_POSITION);

    fill(COLOR_WHITE);
    arc(0, 0, CIRCLE_DIAMETER, CIRCLE_DIAMETER, 0, PI, CHORD);

    rotate(PI/4.5);
    fill(COLOR_GREY_LIGHT);

    final int powerButtonX = -3;
    final int powerButtonY = 50;
    final int proxSensorX = -17;
    final int proxSensorY = 72;

    rect(
      powerButtonX, powerButtonY,
      POWER_BUTTON_SIZE, POWER_BUTTON_SIZE
    );

    // Proximity sensor
    rect(
      proxSensorX, proxSensorY,
      PROX_SENSOR_WIDTH, PROX_SENSOR_HEIGHT
    );

    noFill();
    popMatrix();

    p1.drawMe();
    pwr.drawMe();
    p2.drawMe();
  }

}
