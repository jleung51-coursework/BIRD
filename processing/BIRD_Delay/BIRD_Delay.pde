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

boolean padPower;
boolean padLED1;
boolean padLED2;
boolean boxLED1;
boolean boxLED2;

boolean connected = false;

String sendval = "11";

boolean t1 = false;
boolean t2 = false;

// Text
static final String TEXT_HOURS = "Hours";
static final String TEXT_MINUTES = "Minutes";
static final String TEXT_SECONDS = "Seconds";
static final String TEXT_TITLE = "BIRD Delay";
static final String TEXT_DELAY_SET1_TITLE = "Essential Pad";
static final String TEXT_DELAY_SET2_TITLE = "Other Pad";

// Delay-set locations
static final int DELAY_SET1_X = 30;
static final int DELAY_SET2_X = 542;
static final int DELAY_SET_Y = 150;

// Button sizes
static final int ARROW_BUTTON_SIZE = 30;
static final int DELAY_BUTTON_WIDTH = 80;
static final int DELAY_BUTTON_HEIGHT = 40;

// Text sizes
static final int TEXT_SIZE_TIMER = 25;
static final int TEXT_SIZE_TITLE = 40;
static final int TEXT_SIZE_DELAY_SET_TITLES = 30;

// Button offsets
static final int ARROW_BUTTON_HORIZ_OFFSET = 150;
static final int ARROW_BUTTON_VERT_OFFSET = 80;
static final int DELAY_BUTTON_HORIZ_OFFSET = 180;
static final int DELAY_BUTTON_VERT_OFFSET = 140;

// Number offsets
static final int TIME_SET_HORIZ_OFFSET = ARROW_BUTTON_HORIZ_OFFSET;
static final int TIME_SET_VERT_OFFSET = 65;
static final int TIME_SHOW_HORIZ_START_OFFSET = 160;
static final int TIME_SHOW_HORIZ_OFFSET = 50;
static final int TIME_SHOW_VERT_OFFSET = 230;

// Text offsets
static final int TIME_SHOW_TEXT_HORIZ_START_OFFSET = 40;
static final int TIME_SHOW_TEXT_HORIZ_OFFSET = TIME_SET_HORIZ_OFFSET;
static final int TITLE_HORIZ_OFFSET = 450;
static final int TITLE_VERT_OFFSET = 65;
static final int DELAY_SET1_TITLE_HORIZ_OFFSET = 155;
static final int DELAY_SET2_TITLE_HORIZ_OFFSET = 680;
static final int DELAY_SET_TITLE_VERT_OFFSET = 120;

// Colors
final color COLOR_GREY_DARK = color(128, 128, 128);
final color COLOR_WHITE = color(255, 255, 255);
final color COLOR_BACKGROUND = COLOR_GREY_DARK;
final color COLOR_TEXT = COLOR_WHITE;

void setup() {
  size (1024,768);

  port = new Serial(this, "/dev/ttyUSB0", 9600);

  //----------------------------------------------------------------------------
  // Delay For The First Pressure Pad
  hourUpButton1 = new UpButton(
    DELAY_SET1_X,
    DELAY_SET_Y,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  hourDownButton1 = new DownButton(
    DELAY_SET1_X,
    DELAY_SET_Y + ARROW_BUTTON_VERT_OFFSET,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  minuteUpButton1 = new UpButton(
    DELAY_SET1_X + ARROW_BUTTON_HORIZ_OFFSET,
    DELAY_SET_Y,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  minuteDownButton1 = new DownButton(
    DELAY_SET1_X + ARROW_BUTTON_HORIZ_OFFSET,
    DELAY_SET_Y + ARROW_BUTTON_VERT_OFFSET,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  secondUpButton1 = new UpButton(
    DELAY_SET1_X + ARROW_BUTTON_HORIZ_OFFSET*2,
    DELAY_SET_Y,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  secondDownButton1 = new DownButton(
    DELAY_SET1_X + ARROW_BUTTON_HORIZ_OFFSET*2,
    DELAY_SET_Y + ARROW_BUTTON_VERT_OFFSET,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );

  delayButton1 = new DelayButton(
    DELAY_SET1_X + DELAY_BUTTON_HORIZ_OFFSET,
    DELAY_SET_Y + DELAY_BUTTON_VERT_OFFSET,
    DELAY_BUTTON_WIDTH, DELAY_BUTTON_HEIGHT
  );

  panel1 = new Delay();

  //----------------------------------------------------------------------------
  // Delay For The Second Pressure Pad
  hourUpButton2 = new UpButton(
    DELAY_SET2_X,
    DELAY_SET_Y,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  hourDownButton2 = new DownButton(
    DELAY_SET2_X,
    DELAY_SET_Y + ARROW_BUTTON_VERT_OFFSET,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  minuteUpButton2 = new UpButton(
    DELAY_SET2_X + ARROW_BUTTON_HORIZ_OFFSET,
    DELAY_SET_Y,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  minuteDownButton2 = new DownButton(
    DELAY_SET2_X + ARROW_BUTTON_HORIZ_OFFSET,
    DELAY_SET_Y + ARROW_BUTTON_VERT_OFFSET,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  secondUpButton2 = new UpButton(
    DELAY_SET2_X + ARROW_BUTTON_HORIZ_OFFSET*2,
    DELAY_SET_Y,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  secondDownButton2 = new DownButton(
    DELAY_SET2_X + ARROW_BUTTON_HORIZ_OFFSET*2,
    DELAY_SET_Y + ARROW_BUTTON_VERT_OFFSET,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );

  delayButton2 = new DelayButton(
    DELAY_SET2_X + DELAY_BUTTON_HORIZ_OFFSET,
    DELAY_SET_Y + DELAY_BUTTON_VERT_OFFSET,
    DELAY_BUTTON_WIDTH, DELAY_BUTTON_HEIGHT
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

  background(COLOR_BACKGROUND);

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

  textSize(TEXT_SIZE_TIMER);

  // Numbers for setting the timer
  text(
    panel1.hour,
    DELAY_SET1_X,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    panel1.minute,
    DELAY_SET1_X + TIME_SET_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    panel1.second,
    DELAY_SET1_X + TIME_SET_HORIZ_OFFSET*2,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );

  // Numbers for displaying the timer
  text(
    panel1.timerH,
    DELAY_SET1_X + TIME_SHOW_HORIZ_START_OFFSET,
    DELAY_SET_Y + TIME_SHOW_VERT_OFFSET
  );
  text(
    panel1.timerM,
    DELAY_SET1_X
    + TIME_SHOW_HORIZ_START_OFFSET
    + TIME_SHOW_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SHOW_VERT_OFFSET
  );
  text(
    panel1.timerS,
    DELAY_SET1_X
    + TIME_SHOW_HORIZ_START_OFFSET
    + TIME_SHOW_HORIZ_OFFSET*2,
    DELAY_SET_Y + TIME_SHOW_VERT_OFFSET
  );

  // Text labels for setting the timer
  text(
    TEXT_HOURS,
    DELAY_SET1_X + TIME_SHOW_TEXT_HORIZ_START_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    TEXT_MINUTES,
    DELAY_SET1_X
    + TIME_SHOW_TEXT_HORIZ_START_OFFSET
    + TIME_SHOW_TEXT_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    TEXT_SECONDS,
    DELAY_SET1_X
    + TIME_SHOW_TEXT_HORIZ_START_OFFSET
    + TIME_SHOW_TEXT_HORIZ_OFFSET*2,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );

  //----------------------------------------------------------------------------
  //Second Pressure Pad
  hourUpButton2.drawMe();
  hourDownButton2.drawMe();

  minuteUpButton2.drawMe();
  minuteDownButton2.drawMe();

  secondUpButton2.drawMe();
  secondDownButton2.drawMe();

  delayButton2.drawMe();

  textSize(TEXT_SIZE_TIMER);

  // Numbers for setting the timer
  text(
    panel2.hour,
    DELAY_SET2_X,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    panel2.minute,
    DELAY_SET2_X + TIME_SET_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    panel2.second,
    DELAY_SET2_X + TIME_SET_HORIZ_OFFSET*2,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );

  // Numbers for displaying the timer
  text(
    panel2.timerH,
    DELAY_SET2_X + TIME_SHOW_HORIZ_START_OFFSET,
    DELAY_SET_Y + TIME_SHOW_VERT_OFFSET
  );
  text(
    panel2.timerM,
    DELAY_SET2_X
    + TIME_SHOW_HORIZ_START_OFFSET
    + TIME_SHOW_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SHOW_VERT_OFFSET
  );
  text(
    panel2.timerS,
    DELAY_SET2_X
    + TIME_SHOW_HORIZ_START_OFFSET
    + TIME_SHOW_HORIZ_OFFSET*2,
    DELAY_SET_Y + TIME_SHOW_VERT_OFFSET
  );

  // Text labels for setting the timer
  text(
    TEXT_HOURS,
    DELAY_SET2_X + TIME_SHOW_TEXT_HORIZ_START_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    TEXT_MINUTES,
    DELAY_SET2_X
    + TIME_SHOW_TEXT_HORIZ_START_OFFSET
    + TIME_SHOW_TEXT_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    TEXT_SECONDS,
    DELAY_SET2_X
    + TIME_SHOW_TEXT_HORIZ_START_OFFSET
    + TIME_SHOW_TEXT_HORIZ_OFFSET*2,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );

  //----------------------------------------------------------------------------
  ppad.drawMe();
  cbox.drawMe();

  // Text
  fill(COLOR_TEXT);
  textSize(TEXT_SIZE_TITLE);
  text(
    TEXT_TITLE,
    TITLE_HORIZ_OFFSET, TITLE_VERT_OFFSET
  );

  textSize(TEXT_SIZE_DELAY_SET_TITLES);
  text(
    TEXT_DELAY_SET1_TITLE,
    DELAY_SET1_TITLE_HORIZ_OFFSET, DELAY_SET_TITLE_VERT_OFFSET
  );

  textSize(TEXT_SIZE_DELAY_SET_TITLES);
  text(
    TEXT_DELAY_SET2_TITLE,
    DELAY_SET2_TITLE_HORIZ_OFFSET, DELAY_SET_TITLE_VERT_OFFSET
  );
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
