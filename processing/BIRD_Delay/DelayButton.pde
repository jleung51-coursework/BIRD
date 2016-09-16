/*
 * This Processing class implements a button which can be used to activate
 * a delay for the BIRD system alert.
 *
 */

class DelayButton extends Button {

  private final color COLOR_WHITE = color(255);

  private static final String TEXT_DELAY = "Delay";

  public DelayButton(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  public void drawMe(){
    super.drawMe();

    fill(COLOR_WHITE);
    textSize(buttonW/3);
    text(
      TEXT_DELAY,
      buttonX + buttonW/12,
      buttonY + buttonH*3/4
    );
  }

}
