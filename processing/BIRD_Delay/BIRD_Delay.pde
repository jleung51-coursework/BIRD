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

int delaySet1_x = 30;
int delaySet2_x = 542;
int delaySet_y = 150;

boolean padPower;
boolean padLED1;
boolean padLED2;
boolean boxLED1;
boolean boxLED2;

boolean connected = false;

String sendval = "11";

boolean t1 = false;
boolean t2 = false;

// Button sizes
final int arrowButtonSize = 30;
final int delayButtonWidth = 80;
final int delayButtonHeight = 40;

// Button offsets
final int arrowButtonHorizOffset = 150;
final int arrowButtonVertOffset = 80;
final int delayButtonHorizOffset = 180;
final int delayButtonVertOffset = 140;

// Number offsets
final int timeSetHorizOffset = arrowButtonHorizOffset;
final int timeSetVertOffset = 65;
final int timeShowHorizStartOffset = 160;
final int timeShowHorizOffset = 50;
final int timeShowVertOffset = 230;

void setup() {
  size (1024,768);

  port = new Serial(this, "/dev/ttyUSB0", 9600);

  //----------------------------------------------------------------------------
  // Delay For The First Pressure Pad
  hourUpButton1 = new UpButton(
    delaySet1_x, delaySet_y,
    arrowButtonSize, arrowButtonSize
  );
  hourDownButton1 = new DownButton(
    delaySet1_x, delaySet_y + arrowButtonVertOffset,
    arrowButtonSize, arrowButtonSize
  );
  minuteUpButton1 = new UpButton(
    delaySet1_x + arrowButtonHorizOffset, delaySet_y,
    arrowButtonSize, arrowButtonSize
  );
  minuteDownButton1 = new DownButton(
    delaySet1_x + arrowButtonHorizOffset, delaySet_y + arrowButtonVertOffset,
    arrowButtonSize, arrowButtonSize
  );
  secondUpButton1 = new UpButton(
    delaySet1_x + arrowButtonHorizOffset*2, delaySet_y,
    arrowButtonSize, arrowButtonSize
  );
  secondDownButton1 = new DownButton(
    delaySet1_x + arrowButtonHorizOffset*2, delaySet_y + arrowButtonVertOffset,
    arrowButtonSize, arrowButtonSize
  );

  delayButton1 = new DelayButton(
    delaySet1_x + delayButtonHorizOffset, delaySet_y + delayButtonVertOffset,
    delayButtonWidth, delayButtonHeight
  );

  panel1 = new Delay();

  //----------------------------------------------------------------------------
  // Delay For The Second Pressure Pad
  hourUpButton2 = new UpButton(
    delaySet2_x, delaySet_y,
    arrowButtonSize, arrowButtonSize
  );
  hourDownButton2 = new DownButton(
    delaySet2_x, delaySet_y + arrowButtonVertOffset,
    arrowButtonSize, arrowButtonSize
  );
  minuteUpButton2 = new UpButton(
    delaySet2_x + arrowButtonHorizOffset, delaySet_y,
    arrowButtonSize, arrowButtonSize
  );
  minuteDownButton2 = new DownButton(
    delaySet2_x + arrowButtonHorizOffset, delaySet_y + arrowButtonVertOffset,
    arrowButtonSize, arrowButtonSize
  );
  secondUpButton2 = new UpButton(
    delaySet2_x + arrowButtonHorizOffset*2, delaySet_y,
    arrowButtonSize, arrowButtonSize
  );
  secondDownButton2 = new DownButton(
    delaySet2_x + arrowButtonHorizOffset*2, delaySet_y + arrowButtonVertOffset,
    arrowButtonSize, arrowButtonSize
  );

  delayButton2 = new DelayButton(
    delaySet2_x + delayButtonHorizOffset, delaySet_y + delayButtonVertOffset,
    delayButtonWidth, delayButtonHeight
  );

  panel2 = new Delay();

  ppad = new Pad();
  cbox = new Box();
}

void draw() {
  //----------------------------------------------------------------------------
  // Arduino Connection

  // Arduino to Processing

  connected = port.available() > 0;
  if (connected) {
    val = port.readStringUntil('\n');
    if(val != null){
      val = trim(val);  // Remove excess whitespace at beginning/end
    }
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

  text(
    panel1.hour,
    delaySet1_x, delaySet_y + timeSetVertOffset
  );
  text(
    panel1.minute,
    delaySet1_x + timeSetHorizOffset, delaySet_y + timeSetVertOffset
  );
  text(
    panel1.second,
    delaySet1_x + timeSetHorizOffset*2, delaySet_y + timeSetVertOffset
  );

  text(
    panel1.timerH,
    delaySet1_x + timeShowHorizStartOffset,
    delaySet_y + timeShowVertOffset
  );
  text(
    panel1.timerM,
    delaySet1_x + timeShowHorizStartOffset + timeShowHorizOffset,
    delaySet_y + timeShowVertOffset
  );
  text(
    panel1.timerS,
    delaySet1_x + timeShowHorizStartOffset + timeShowHorizOffset*2,
    delaySet_y + timeShowVertOffset
  );

  textSize(25);
  text("Hours",delaySet1_x+40,delaySet_y+65);
  text("Minutes",delaySet1_x+190,delaySet_y+65);
  text("Seconds",delaySet1_x+340,delaySet_y+65);

  //----------------------------------------------------------------------------
  //Second Pressure Pad
  hourUpButton2.drawMe();
  hourDownButton2.drawMe();

  minuteUpButton2.drawMe();
  minuteDownButton2.drawMe();

  secondUpButton2.drawMe();
  secondDownButton2.drawMe();

  delayButton2.drawMe();

  text(
    panel2.hour,
    delaySet2_x, delaySet_y + timeSetVertOffset);
  text(
    panel2.minute,
    delaySet2_x + timeSetHorizOffset, delaySet_y + timeSetVertOffset
  );
  text(
    panel2.second,
    delaySet2_x + timeSetHorizOffset*2, delaySet_y + timeSetVertOffset
  );

  text(
    panel2.timerH,
    delaySet2_x + timeShowHorizStartOffset,
    delaySet_y + timeShowVertOffset
  );
  text(
    panel2.timerM,
    delaySet2_x + timeShowHorizStartOffset + timeShowHorizOffset,
    delaySet_y + timeShowVertOffset
  );
  text(
    panel2.timerS,
    delaySet2_x + timeShowHorizStartOffset + timeShowHorizOffset*2,
    delaySet_y + timeShowVertOffset
  );

  textSize(25);
  text("Hours",delaySet2_x+40,delaySet_y+65);
  text("Minutes",delaySet2_x+190,delaySet_y+65);
  text("Seconds",delaySet2_x+340,delaySet_y+65);

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
