import processing.serial.*;
Serial port;
String val;

UpButton hourUpButton1;
UpButton hourUpButton2;
DownButton hourDownButton1;
DownButton hourDownButton2;

UpButton minuteUpButton1;
UpButton minuteUpButton2;
DownButton minuteDownButton1;
DownButton minuteDownButton2;

UpButton secondUpButton1;
UpButton secondUpButton2;
DownButton secondDownButton1;
DownButton secondDownButton2;

DelayButton delayButton1;
DelayButton delayButton2;
Delay panel1;
Delay panel2;

Pad ppad;
Box cbox;

int delaynum1 = 30;
int delaynum2 = 542;
int delaynum3 = 150;

boolean padPower = false;
boolean padLED1 = false;
boolean padLED2 = false;
boolean boxLED1 = false;
boolean boxLED2 = false;

boolean connected = false;

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
  background(128,128,128);


  //----------------------------------------------------------------------------
  // Arduino Connection

  // Arduino to Processing

  if (port.available() > 0) {
    val = port.readStringUntil('\n');
    if(val != null){
      val = trim(val);  // Remove excess whitespace at beginning/end
    }
    connected = true;
  }
  else {
    connected = false;
  }

  if(val != null){
    // Pad Power
    padPower = val.equals("20");

    padLED1 = (val.charAt(0) == '1');
    boxLED1 = padLED1;

    padLED2 = (val.charAt(1) == '1');
    boxLED2 = padLED1;
  }

  // Processing to Arduino

  t1 = panel1.signal;
  t2 = panel2.signal;

  char sendVal1;
  char sendVal2;

  if(t1) {
    sendVal1 = '1';
  }
  else {
    sendVal1 = '0';
  }

  if(t2) {
    sendVal2 = '1';
  }
  else {
    sendVal2 = '0';
  }

  if(connected){
    port.write(sendVal1);
    port.write(sendVal2);
  }

  //----------------------------------------------------------------------------
  // Update

  ppad.update(padLED1, padPower, padLED2);

  //----------------------------------------------------------------------------
  // Delay For The First Pressure Pad
  hourUpButton1.update(mouseX, mouseY);
  hourDownButton1.update(mouseX, mouseY);

  minuteUpButton1.update(mouseX, mouseY);
  minuteDownButton1.update(mouseX, mouseY);

  secondUpButton1.update(mouseX, mouseY);
  secondDownButton1.update(mouseX, mouseY);

  delayButton1.update(mouseX, mouseY);

  panel1.update();

  //----------------------------------------------------------------------------
  // Delay For The Second Pressure Pad
  hourUpButton2.update(mouseX, mouseY);
  hourDownButton2.update(mouseX, mouseY);

  minuteUpButton2.update(mouseX, mouseY);
  minuteDownButton2.update(mouseX, mouseY);

  secondUpButton2.update(mouseX, mouseY);
  secondDownButton2.update(mouseX, mouseY);

  delayButton2.update(mouseX, mouseY);

  panel2.update();

  //----------------------------------------------------------------------------
  // LEDs

  // P-Pad - Power LED
  if(padPower){
    ppad.pwr.turnOn();
  }
  else{
    ppad.pwr.turnOff();
  }

  // P-Pad - LED Essential Pad
  if(padLED1){
    ppad.p1.turnOn();
  }
  else{
    ppad.p1.turnOff();
  }

  // P-Pad - LED Other Pad
  if(padLED2){
    ppad.p2.turnOn();
  }
  else{
    ppad.p2.turnOff();
  }

  // C-Box - Power LED
  cbox.pwr.turnOn();

  // C-Box - LED Essential Pad
  if(panel1.signal && boxLED1){
    cbox.p1.turnOn();
  }
  else{
    cbox.p1.turnOff();
  }

  // C-Box - LED Other Pad
  if(panel2.signal && boxLED2){
    cbox.p2.turnOn();
  }
  else{
    cbox.p2.turnOff();
  }

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

  text(panel1.setHour,delaynum1,delaynum3+65);
  text(panel1.setMinute,delaynum1+150,delaynum3+65);
  text(panel1.setSecond,delaynum1+300,delaynum3+65);

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

  text(panel2.setHour,delaynum2,delaynum3+65);
  text(panel2.setMinute,delaynum2+150,delaynum3+65);
  text(panel2.setSecond,delaynum2+300,delaynum3+65);

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
    panel1.activate(
      panel1.setHour,
      panel1.setMinute,
      panel1.setSecond
    );
  }
  if (hourUpButton1.buttonOver) {
    panel1.setHour = hourUpButton1.increase(panel1.setHour);
  }
  if (hourDownButton1.buttonOver) {
    panel1.setHour = hourDownButton1.decrease(panel1.setHour);
  }
  if (minuteUpButton1.buttonOver) {
    panel1.setMinute = minuteUpButton1.increase(panel1.setMinute);
    if (panel1.setMinute == 60) {
      panel1.setMinute = 0;
    }
  }
  if (minuteDownButton1.buttonOver) {
    panel1.setMinute = minuteDownButton1.decrease(panel1.setMinute);
  }
  if (secondUpButton1.buttonOver) {
    panel1.setSecond = secondUpButton1.increase(panel1.setSecond);
    if (panel1.setSecond == 60) {
      panel1.setSecond = 0;
    }
  }
  if (secondDownButton1.buttonOver) {
    panel1.setSecond = secondDownButton1.decrease(panel1.setSecond);
  }

  //----------------------------------------------------------------------------
  //Delay For First Pressure Pad
  if (delayButton2.buttonOver) {
    panel2.activate(
      panel2.setHour,
      panel2.setMinute,
      panel2.setSecond
    );
  }
  if (hourUpButton2.buttonOver) {
    panel2.setHour = hourUpButton2.increase(panel2.setHour);
  }
  if (hourDownButton2.buttonOver) {
    panel2.setHour = hourDownButton1.decrease(panel2.setHour);
  }
  if (minuteUpButton2.buttonOver) {
    panel2.setMinute = minuteUpButton2.increase(panel2.setMinute);
    if (panel2.setMinute == 60) {
      panel2.setMinute = 0;
    }
  }
  if (minuteDownButton2.buttonOver) {
    panel2.setMinute = minuteDownButton1.decrease(panel2.setMinute);
  }
  if (secondUpButton2.buttonOver) {
    panel2.setSecond = secondUpButton2.increase(panel2.setSecond);
    if (panel2.setSecond == 60) {
      panel2.setSecond = 0;
    }
  }
  if (secondDownButton2.buttonOver) {
    panel2.setSecond = secondDownButton2.decrease(panel2.setSecond);
  }
}
