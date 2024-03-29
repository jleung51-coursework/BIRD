/*
 * This Processing class implements a button which can be used to increment
 * a value used to delay the BIRD system.
 *
 */

class UpButton extends Button {

  private final color COLOR_WHITE = color(255);

  public UpButton(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  public int increase(int num) {
    // The first rule of BIRD_Delay is:
    // You do not ask about INT_MAX.
    return num+1;
  }

  @Override
  public void drawMe(){
    super.drawMe();

    fill(COLOR_WHITE);
    triangle(
      buttonX + buttonW/2, buttonY + buttonH/4,
      buttonX + buttonW - buttonW/4, buttonY + buttonH - buttonH/4,
      buttonX + buttonW/4, buttonY + buttonH - buttonH/4
    );
  }

}
