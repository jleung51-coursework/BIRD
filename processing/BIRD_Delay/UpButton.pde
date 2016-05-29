class UpButton extends Button {

  final color COLOR_WHITE = color(255);

  UpButton(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  int increase(int num) {
    // The first rule of BIRD_Delay is:
    // You do not ask about INT_MAX.
    return num+1;
  }

  void drawMe(){
    super.drawMe();

    fill(COLOR_WHITE);
    triangle(
      buttonX + buttonW/2, buttonY + buttonH/4,
      buttonX + buttonW - buttonW/4, buttonY + buttonH - buttonH/4,
      buttonX + buttonW/4, buttonY + buttonH - buttonH/4
    );
  }

}
