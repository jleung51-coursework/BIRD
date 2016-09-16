/*
 * This Processing class implements an interactive button which is highlighted
 * when the mouse is held over it.
 *
 */

class Button {

  protected final int buttonX;
  protected final int buttonY;
  protected final int buttonW;
  protected final int buttonH;

  private final color COLOR_BLACK = color(0);
  private final color COLOR_GREY_DARK = color(51);
  private final color COLOR_GREY = color(102);
  private final color COLOR_WHITE = color(255);

  private final color COLOR_BUTTON_NORMAL = COLOR_BLACK;
  private final color COLOR_BUTTON_HIGHLIGHT = COLOR_GREY_DARK;
  private final color COLOR_BUTTON_OUTLINE = COLOR_WHITE;

  private boolean buttonOver;

  public Button(int x, int y, int w, int h) {
    buttonX = x;
    buttonY = y;
    buttonW = w;
    buttonH = h;
    buttonOver = false;
  }

  public void update(int x, int y) {
    buttonOver = isOverButton();
  }

  public boolean isOverButton() {
    return buttonX < mouseX && mouseX < (buttonX + buttonW) &&
           buttonY < mouseY && mouseY < (buttonY + buttonH);
  }

  public void drawMe() {
    if (buttonOver) {
      fill(COLOR_BUTTON_HIGHLIGHT);
    }
    else {
      fill(COLOR_BUTTON_NORMAL);
    }
    stroke(COLOR_BUTTON_OUTLINE);
    rect(buttonX, buttonY, buttonW, buttonH);
  }

}
