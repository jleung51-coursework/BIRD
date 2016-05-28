/*
 * This Processing class implements a button which can be used to increment
 * a value used to delay the BIRD system.
 *
 */

class UpButton extends Button {

  UpButton(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  int increase(int num) {
    num++;
    return num;
  }

  void drawMe(){
   super.drawMe();
   fill(255, 255, 255);
   triangle(buttonX + buttonW/2, buttonY + buttonH/4,
    buttonX + buttonW - buttonW/4, buttonY + buttonH - buttonH/4,
    buttonX + buttonW/4, buttonY + buttonH - buttonH/4);
  }

}
