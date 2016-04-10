class Pad {
  int xPos;
  int yPos;
  LED p1;
  LED pwr;
  LED p2;
  
  Pad() {
    xPos = 50;
    yPos = 425;
    p1 = new LED(xPos+100,yPos+90,color(0,255,255));
    pwr = new LED(xPos+200,yPos+90,color(0,255,0));
    p2 = new LED(xPos+300,yPos+90,color(255,255,0));
  }
  
  void update() {
    
    
  }
  
  void drawMe() {
    stroke(10);
    rect(xPos,yPos,400,300);
    
    fill(color(200,200,200));
    rect(xPos+185,yPos+20,30,30);
    p1.drawMe();
    pwr.drawMe();
    p2.drawMe();
    
    fill(color(200,200,200));
    rect(xPos+30,yPos+130, 140,140);
    rect(xPos+230,yPos+130, 140,140);
  }
  