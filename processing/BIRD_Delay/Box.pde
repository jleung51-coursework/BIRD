class Box {
  LED p1;
  LED pwr;
  LED p2;

  static final int X_POSITION = 860;
  static final int Y_POSITION = 550;

  static final int LED1_X = X_POSITION + 4;
  static final int LED1_Y = Y_POSITION + 78;

  static final int LED_POWER_X = X_POSITION + 40;
  static final int LED_POWER_Y = Y_POSITION + 68;

  static final int LED2_X = X_POSITION + 66;
  static final int LED2_Y = Y_POSITION + 42;

  static final int CIRCLE_DIAMETER = 150;
  static final int POWER_BUTTON_SIZE = 15;
  static final int PROX_SENSOR_WIDTH = 40;
  static final int PROX_SENSOR_HEIGHT = 15;

  final color COLOR_WHITE = color(255, 255, 255);
  final color COLOR_GREY_LIGHT = color(200, 200, 200);
  final color COLOR_RED = color(255, 0, 0);
  final color COLOR_GREEN = color(0, 255, 0);
  final color COLOR_YELLOW = color(255, 255, 0);

  Box() {
    p1 = new LED(LED1_X, LED1_Y, COLOR_RED);
    pwr = new LED(LED_POWER_X, LED_POWER_Y, COLOR_GREEN);
    p2 = new LED(LED2_X, LED2_Y, COLOR_YELLOW);
  }

  void update(){
  }

  void drawMe() {
    pushMatrix();
    translate(X_POSITION, Y_POSITION);

    fill(COLOR_WHITE);
    arc(0, 0, CIRCLE_DIAMETER, CIRCLE_DIAMETER, 0, PI);

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
