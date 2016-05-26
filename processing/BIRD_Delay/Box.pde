class Box {
  LED p1;
  LED pwr;
  LED p2;

  final int xPos = 860;
  final int yPos = 550;

  final int LED1_x = xPos + 4;
  final int LED1_y = yPos + 78;

  final int LEDpwr_x = xPos + 40;
  final int LEDpwr_y = yPos + 68;

  final int LED2_x = xPos + 66;
  final int LED2_y = yPos + 42;

  final int circleDiameter = 150;
  final int powerButtonSize = 15;
  final int proxSensorWidth = 40;
  final int proxSensorHeight = 15;

  final color colorWhite = color(255, 255, 255);
  final color colorGreyLight = color(200, 200, 200);
  final color colorRed = color(255, 0, 0);
  final color colorGreen = color(0, 255, 0);
  final color colorYellow = color(255, 255, 0);

  Box() {
    p1 = new LED(LED1_x, LED1_y, colorRed);
    pwr = new LED(LEDpwr_x, LEDpwr_y, colorGreen);
    p2 = new LED(LED2_x, LED2_y, colorYellow);
  }

  void update(){
  }

  void drawMe() {
    pushMatrix();
    translate(xPos, yPos);

    fill(colorWhite);
    arc(0, 0, circleDiameter, circleDiameter, 0, PI);

    rotate(PI/4.5);
    fill(colorGrey);

    final int powerButtonX = -3;
    final int powerButtonY = 50;
    final int proxSensorX = -17;
    final int proxSensorY = 72;

    rect(
      powerButtonX, powerButtonY,
      powerButtonSize, powerButtonSize
    );

    // Proximity sensor
    rect(
      proxSensorX, proxSensorY,
      proxSensorWidth, proxSensorHeight
    );

    noFill();
    popMatrix();

    p1.drawMe();
    pwr.drawMe();
    p2.drawMe();
  }

}
