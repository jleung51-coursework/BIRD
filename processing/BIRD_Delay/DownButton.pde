/*
 * This Processing class implements a button which can be used to decrement
 * a value used to delay the BIRD system.
 *
 */

class DownButton extends Button {

  DownButton(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  int decrease(int num) {
    num--;
    if (num < 0) {
      num = 0;
    }
    return num;
  }

  void drawMe(){
    super.drawMe();
    fill(255, 255, 255);
    triangle(buttonX + buttonW/2, buttonY + buttonH - buttonH/4,
    buttonX + buttonW - buttonW/4, buttonY + buttonH/4,
    buttonX + buttonW/4, buttonY + buttonH/4);
  }

}
