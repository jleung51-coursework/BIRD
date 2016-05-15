import processing.serial.*;
Serial port;
String val;

UpButton hourUpButton1, hourUpButton2;
DownButton hourDownButton1, hourDownButton2;

UpButton minuteUpButton1, minuteUpButton2;
DownButton minuteDownButton1, minuteDownButton2;

UpButton secondUpButton1, secondUpButton2;
DownButton secondDownButton1, secondDownButton2;

DelayButton delayButton1, delayButton2;
Delay panel1, panel2;

Pad ppad;
Box cbox;

int delaynum1 = 30;
int delaynum2 = 542;
int delaynum3 = 150;

boolean padPower, padLED1, padLED2;
boolean boxLED1, boxLED2;

boolean connected = false;

String sendval = "11";

boolean t1 = false;
boolean t2 = false;


void setup() {
  size (1024,768);

  port = new Serial(this, "/dev/ttyUSB0", 9600);

  //----------------------------------------------------------------------------
  // Delay For The First Pressure Pad
  hourUpButton1 = new UpButton(delaynum1,delaynum3,30,30);
  hourDownButton1 = new DownButton(delaynum1,delaynum3+80,30,30);
  minuteUpButton1 = new UpButton(delaynum1+150,delaynum3,30,30);
  minuteDownButton1 = new DownButton(delaynum1+150,delaynum3+80,30,30);
  secondUpButton1 = new UpButton(delaynum1+300,delaynum3,30,30);
  secondDownButton1 = new DownButton(delaynum1+300,delaynum3+80,30,30);

  delayButton1 = new DelayButton(delaynum1+180,delaynum3+140,80,40);

  panel1 = new Delay();

  //----------------------------------------------------------------------------
  // Delay For The Second Pressure Pad
  hourUpButton2 = new UpButton(delaynum2,delaynum3,30,30);
  hourDownButton2 = new DownButton(delaynum2,delaynum3+80,30,30);
  minuteUpButton2 = new UpButton(delaynum2+150,delaynum3,30,30);
  minuteDownButton2 = new DownButton(delaynum2+150,delaynum3+80,30,30);
  secondUpButton2 = new UpButton(delaynum2+300,delaynum3,30,30);
  secondDownButton2 = new DownButton(delaynum2+300,delaynum3+80,30,30);

  delayButton2 = new DelayButton(delaynum2+180,delaynum3+140,80,40);

  panel2 = new Delay();

  ppad = new Pad();
  cbox = new Box();
}

void draw() {
  //----------------------------------------------------------------------------
  // Arduino Connection

  // Arduino to Processing

  if ( port.available() > 0) {
    val = port.readStringUntil('\n');
    if(val != null){
      val = trim(val);
    }
    connected = true;
  }
  else {
    connected = false;
  }
  println(val);

  if(val != null){
  // Pad Power
    if(val.equals("20")){
      padPower = true;
    }

    if(val.equals("21")){
      padPower = false;
    }

  // Pad LED 1
    if(val.equals("10") || val.equals("11")){
      padLED1 = true;
      boxLED1 = true;
    }

    if(val.equals("00") || val.equals("01")){
      padLED1 = false;
      boxLED1 = false;
    }

  // Pad LED 2
    if(val.equals("01") || val.equals("11")){
      padLED2 = true;
      boxLED2 = true;
    }

    if(val.equals("00") || val.equals("10")){
      padLED2 = false;
      boxLED2 = false;
    }
  }

  // Processing to Arduino

  if(panel1.signal == 0){
    t1 = false;
  }
  if(panel1.signal == 1){
    t1 = true;
  }

  //Delay 2
  if(panel2.signal == 0){
    t2 = false;
  }
  if(panel2.signal == 1){
    t2 = true;
  }

  if( !t1 && !t2 ) {
    sendval = "00";
  }
  if( t1 && !t2 ) {
    sendval = "10";
  }
  if( !t1 && t2 ) {
    sendval = "01";
  }
  if( t1 && t2 ) {
    sendval = "11";
  }

  if(connected){
   port.write(sendval);
  }

  //----------------------------------------------------------------------------
  // Update

  ppad.update(padLED1,padPower,padLED2);

  //----------------------------------------------------------------------------
  // Delay For The First Pressure Pad
  hourUpButton1.update(mouseX,mouseY);
  hourDownButton1.update(mouseX,mouseY);

  minuteUpButton1.update(mouseX,mouseY);
  minuteDownButton1.update(mouseX,mouseY);

  secondUpButton1.update(mouseX,mouseY);
  secondDownButton1.update(mouseX,mouseY);

  delayButton1.update(mouseX,mouseY);

  panel1.update();

  //----------------------------------------------------------------------------
  // Delay For The Second Pressure Pad
  hourUpButton2.update(mouseX,mouseY);
  hourDownButton2.update(mouseX,mouseY);

  minuteUpButton2.update(mouseX,mouseY);
  minuteDownButton2.update(mouseX,mouseY);

  secondUpButton2.update(mouseX,mouseY);
  secondDownButton2.update(mouseX,mouseY);

  delayButton2.update(mouseX,mouseY);

  panel2.update();

  //----------------------------------------------------------------------------
  // LEDs

  // PPAD - Power LED
  if(padPower){
    ppad.pwr.turnOn();
  }
  else{
    ppad.pwr.turnOff();
  }

  // PPAD - LED Essential Pad
  if(padLED1){
    ppad.p1.turnOn();
  }
  else{
    ppad.p1.turnOff();
  }

  // PPAD - LED Other Pad
  if(padLED2){
    ppad.p2.turnOn();
  }
  else{
    ppad.p2.turnOff();
  }

  // CBOX - Power LED
    cbox.pwr.turnOn();

  // CBOX - LED Essential Pad
  if(panel1.signal == 1 && boxLED1){
    cbox.p1.turnOn();
  }
  else{
    cbox.p1.turnOff();
  }

  // CBOX - LED Other Pad
  if(panel2.signal == 1 && boxLED2){
    cbox.p2.turnOn();
  }
  else{
    cbox.p2.turnOff();
  }

  background(128,128,128);

  //----------------------------------------------------------------------------
  // Drawings

  //----------------------------------------------------------------------------
  //First Pressure Pad
  hourUpButton1.drawMe();
  hourDownButton1.drawMe();

  minuteUpButton1.drawMe();
  minuteDownButton1.drawMe();

  secondUpButton1.drawMe();
  secondDownButton1.drawMe();

  delayButton1.drawMe();

  text(panel1.hour,delaynum1,delaynum3+65);
  text(panel1.minute,delaynum1+150,delaynum3+65);
  text(panel1.second,delaynum1+300,delaynum3+65);

  text(panel1.timerH,delaynum1+160,delaynum3+230);
  text(panel1.timerM,delaynum1+210,delaynum3+230);
  text(panel1.timerS,delaynum1+260,delaynum3+230);

  textSize(25);
  text("Hours",delaynum1+40,delaynum3+65);
  text("Minutes",delaynum1+190,delaynum3+65);
  text("Seconds",delaynum1+340,delaynum3+65);

  //----------------------------------------------------------------------------
  //Second Pressure Pad
  hourUpButton2.drawMe();
  hourDownButton2.drawMe();

  minuteUpButton2.drawMe();
  minuteDownButton2.drawMe();

  secondUpButton2.drawMe();
  secondDownButton2.drawMe();

  delayButton2.drawMe();

  text(panel2.hour,delaynum2,delaynum3+65);
  text(panel2.minute,delaynum2+150,delaynum3+65);
  text(panel2.second,delaynum2+300,delaynum3+65);

  text(panel2.timerH,delaynum2+160,delaynum3+230);
  text(panel2.timerM,delaynum2+210,delaynum3+230);
  text(panel2.timerS,delaynum2+260,delaynum3+230);

  textSize(25);
  text("Hours",delaynum2+40,delaynum3+65);
  text("Minutes",delaynum2+190,delaynum3+65);
  text("Seconds",delaynum2+340,delaynum3+65);

  //----------------------------------------------------------------------------
  ppad.drawMe();
  cbox.drawMe();

  // Text
  fill(color(255,255,255));
  textSize(40);
  text("BIRD Delay",30,65);

  textSize(30);
  text("Essential Pad",155,120);

  textSize(30);
  text("Other Pad",680,120);
}

void mousePressed() {
  //----------------------------------------------------------------------------
  //Delay For First Pressure Pad
  if (delayButton1.buttonOver) {
    panel1.activate(panel1.hour,panel1.minute,panel1.second);
  }
  if (hourUpButton1.buttonOver) {
    panel1.hour = hourUpButton1.increase(panel1.hour);
  }
  if (hourDownButton1.buttonOver) {
    panel1.hour = hourDownButton1.decrease(panel1.hour);
  }
  if (minuteUpButton1.buttonOver) {
    panel1.minute = minuteUpButton1.increase(panel1.minute);
    if (panel1.minute == 60) {
      panel1.minute = 0;
    }
  }
  if (minuteDownButton1.buttonOver) {
    panel1.minute = minuteDownButton1.decrease(panel1.minute);
  }
  if (secondUpButton1.buttonOver) {
    panel1.second = secondUpButton1.increase(panel1.second);
    if (panel1.second == 60) {
      panel1.second = 0;
    }
  }
  if (secondDownButton1.buttonOver) {
    panel1.second = secondDownButton1.decrease(panel1.second);
  }

  //----------------------------------------------------------------------------
  //Delay For First Pressure Pad
  if (delayButton2.buttonOver) {
    panel2.activate(panel2.hour,panel2.minute,panel2.second);
  }
  if (hourUpButton2.buttonOver) {
    panel2.hour = hourUpButton2.increase(panel2.hour);
  }
  if (hourDownButton2.buttonOver) {
    panel2.hour = hourDownButton1.decrease(panel2.hour);
  }
  if (minuteUpButton2.buttonOver) {
    panel2.minute = minuteUpButton2.increase(panel2.minute);
    if (panel2.minute == 60) {
      panel2.minute = 0;
    }
  }
  if (minuteDownButton2.buttonOver) {
    panel2.minute = minuteDownButton1.decrease(panel2.minute);
  }
  if (secondUpButton2.buttonOver) {
    panel2.second = secondUpButton2.increase(panel2.second);
    if (panel2.second == 60) {
      panel2.second = 0;
    }
  }
  if (secondDownButton2.buttonOver) {
    panel2.second = secondDownButton2.decrease(panel2.second);
  }
}
