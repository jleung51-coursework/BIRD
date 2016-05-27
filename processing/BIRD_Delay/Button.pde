class Button {
  final int buttonX;
  final int buttonY;
  final int buttonW;
  final int buttonH;

  final color COLOR_BLACK = color(0);
  final color COLOR_GREY_DARK = color(51);
  final color COLOR_GREY = color(102);
  final color COLOR_WHITE = color(255);

  final color buttonColor = COLOR_BLACK;
  final color baseColor = COLOR_GREY;
  final color buttonHighlight = COLOR_GREY_DARK;
  final color outlineColor = COLOR_WHITE;
  final color currentColor = baseColor;

  boolean buttonOver;

  Button(int x, int y, int w, int h) {
    buttonX = x;
    buttonY = y;
    buttonW = w;
    buttonH = h;
    buttonOver = false;
  }

  void update(int x, int y) {
    buttonOver = overButton(buttonX, buttonY, buttonW, buttonH);
  }

  boolean overButton(int x, int y, int width, int height)  {
    return mouseX > x && mouseX < x+width &&
           mouseY > y && mouseY < y+height;
  }

  void drawMe () {
    if (buttonOver) {
      fill(buttonHighlight);
    }
    else {
      fill(buttonColor);
    }
    stroke(outlineColor);
    rect(buttonX, buttonY, buttonW, buttonH);
  }

}
