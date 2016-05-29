/*
 * This Processing class implements an LED object which can be colored,
 * activated, or deactivated to show the status of the BIRD system.
 *
 */

class LED {
  final int xPos;
  final int yPos;
  final color col;
  boolean on;

  final int DIAMETER = 10;

  final color COLOR_BLACK = color(0);

  LED(int x, int y, color c) {
    xPos = x;
    yPos = y;
    col = c;
    on = false;
  }

  void turnOn () {
    on = true;
  }

  void turnOff () {
    on = false;
  }

  void drawMe () {
    if(on){
      fill(col);
    }
    else{
      fill(COLOR_BLACK);
    }
    ellipse(xPos, yPos, DIAMETER, DIAMETER);
  }

}
