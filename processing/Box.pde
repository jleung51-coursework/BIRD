class Box {
  int xPos, yPos;
  LED p1;
  LED pwr;
  LED p2;

  Box() {
    xPos = 792;
    yPos = 425;
    p1 = new LED(xPos+30,yPos+175,color(0,255,255));
    pwr = new LED(xPos+100,yPos+145,color(0,255,0));
    p2 = new LED(xPos+150,yPos+95,color(255,255,0));

  }

  void update(){

  }

  void drawMe() {
    fill(color(255,255,255));
    arc(xPos,yPos,350,350,0,PI);

    fill(color(200,200,200));
    rect(xPos-15,yPos+100,30,30);

    p1.drawMe();
    pwr.drawMe();
    p2.drawMe();


    noFill();
    //ellipse(580,345,100,100);

    pushMatrix();
    translate(xPos-155, yPos+85);
    rotate(PI/4.5);

    //line(60,0,60,260);

    fill(color(200,200,200));
    rect(0, 0, 120, 30);

    //noFill();
    //ellipse(60,160,100,100);
    //rect(0, 0, 120, 260);

    popMatrix();


  }


}
