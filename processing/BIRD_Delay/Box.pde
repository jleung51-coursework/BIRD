class Box {
  int xPos, yPos;
  LED p1;
  LED pwr;
  LED p2;
  
  Box() {
    xPos = 860;
    yPos = 550;
    p1 = new LED(xPos+4, yPos+78, color(255, 0, 0));
    pwr = new LED(xPos+40, yPos+68, color(0, 255, 0));
    p2 = new LED(xPos+66, yPos+42, color(255, 255, 0));

  }
  
  void update(){
  
  }

  void drawMe() {
    pushMatrix();
    translate(xPos, yPos);

    fill(color(255, 255, 255));
    arc(0, 0, 150, 150, 0, PI);

    rotate(PI/4.5);
    fill(color(200, 200, 200));
    rect(-3, 50, 15, 15);

    rect(-17, 72, 40, 15);

    noFill();
    popMatrix();
    
    
    p1.drawMe();
    pwr.drawMe();
    p2.drawMe();
  }
  
  
}
