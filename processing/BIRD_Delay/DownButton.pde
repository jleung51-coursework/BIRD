/*
 * This Processing class implements a button which can be used to decrement
 * a value used to delay the BIRD system.
 *
 */

class DownButton extends Button {

  private final color COLOR_WHITE = color(255);

  public DownButton(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  public int decrease(int num) {
    if (num <= 0) {
      return num;
    }
    else {
      return num-1;
    }
  }

  @Override
  public void drawMe(){
    super.drawMe();

    fill(COLOR_WHITE);
    triangle(
      buttonX + buttonW/2, buttonY + buttonH - buttonH/4,
      buttonX + buttonW - buttonW/4, buttonY + buttonH/4,
      buttonX + buttonW/4, buttonY + buttonH/4
    );
  }

}
