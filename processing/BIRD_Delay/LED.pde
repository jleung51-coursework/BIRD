class LED {
  int xPos;
  int yPos;
  color col;
  boolean on;

  LED(int x, int y, color c) {
    xPos = x;
    yPos = y;
    col = c;
    on = false;
  }

  void turnOn () {
    on = true;
  }

  void turnOff () {
    on = false;
  }

  void drawMe () {
    if(on){
      fill(col);
    }
    else{
     fill(0,0,0);
    }
    ellipse(xPos,yPos,10,10);
  }

}
