/*
 * This Processing class implements a button which can be used to activate
 * a delay for the BIRD system alert.
 *
 */

class DelayButton extends Button {

  DelayButton(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  void drawMe(){
    super.drawMe();
    fill(255, 255, 255);
    textSize(buttonW/3);
    text("Delay", buttonX+buttonW/12, buttonY+buttonH*3/4);
  }

}
