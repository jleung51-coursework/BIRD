class Button {
  int buttonX;
  int buttonY;
  int buttonW;
  int buttonH;
  color buttonColor;
  color baseColor;
  color buttonHighlight;
  color currentColor;
  boolean buttonOver;

  Button(int x, int y, int w, int h) {
    buttonColor = color(0);
    buttonHighlight = color(51);
    baseColor = color(102);
    currentColor = baseColor;
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
    stroke(255);
    rect(buttonX, buttonY, buttonW, buttonH);
  }

}
