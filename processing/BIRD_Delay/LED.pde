/*
 * This Processing class implements an LED object which can be colored,
 * activated, or deactivated to show the status of the BIRD system.
 *
 */

class LED {

  private final int xPos;
  private final int yPos;
  private final color col;
  private boolean on;

  private final int DIAMETER = 10;
  private final color COLOR_BLACK = color(0);

  public LED(int x, int y, color c) {
    xPos = x;
    yPos = y;
    col = c;
    on = false;
  }

  public void drawMe () {
    if(on){
      fill(col);
    }
    else{
      fill(COLOR_BLACK);
    }
    ellipse(xPos, yPos, DIAMETER, DIAMETER);
  }

  public void turnOn () {
    on = true;
  }

  public void turnOff () {
    on = false;
  }

}
