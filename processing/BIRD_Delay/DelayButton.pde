class DelayButton extends Button {

  final color COLOR_WHITE = color(255);

  static final String TEXT_DELAY = "Delay";

  DelayButton(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  void drawMe(){
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
