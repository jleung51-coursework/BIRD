/*
 * This Processing file runs an application which shows the status of The
 * BIRD system and allows the user to delay the car alert by a given amount
 * of time.
 *
 */

import processing.serial.*;
Serial port;

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
Delay delay1;
Delay delay2;

Pad ppad;
Box cbox;

boolean padPower;
boolean padLED1;
boolean padLED2;
boolean boxLED1;
boolean boxLED2;

// Text
static final String TEXT_HOURS = "Hours";
static final String TEXT_MINUTES = "Minutes";
static final String TEXT_SECONDS = "Seconds";
static final String TEXT_TITLE = "BIRD Delay";
static final String TEXT_DELAY_SET1_TITLE = "Essential Pad";
static final String TEXT_DELAY_SET2_TITLE = "Other Pad";

// Pad/Box locations
static final int BOX_X = 860;
static final int BOX_Y = 550;

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
final color COLOR_GREY_DARK = color(128);
final color COLOR_WHITE = color(255);
final color COLOR_BACKGROUND = COLOR_GREY_DARK;
final color COLOR_TEXT = COLOR_WHITE;

void setup() {
  size (1024,768);

  port = new Serial(this, "/dev/ttyUSB0", 9600);

  initializeDelaySet1(DELAY_SET1_X, DELAY_SET_Y);
  initializeDelaySet2(DELAY_SET2_X, DELAY_SET_Y);
  ppad = new Pad();
  cbox = new Box(BOX_X, BOX_Y);
}

void draw() {
  background(128,128,128);

  String arduinoInput = receiveFromArduino();
  if(arduinoInput != null) {
    setArduinoStatus(arduinoInput);
    sendArduinoDelaySignal();
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

  delay1.update();

  //----------------------------------------------------------------------------
  // Delay For The Second Pressure Pad
  hourUpButton2.update(mouseX, mouseY);
  hourDownButton2.update(mouseX, mouseY);

  minuteUpButton2.update(mouseX, mouseY);
  minuteDownButton2.update(mouseX, mouseY);

  secondUpButton2.update(mouseX, mouseY);
  secondDownButton2.update(mouseX, mouseY);

  delayButton2.update(mouseX, mouseY);

  delay2.update();

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
  if(delay1.signal && boxLED1){
    cbox.p1.turnOn();
  }
  else{
    cbox.p1.turnOff();
  }

  // C-Box - LED Other Pad
  if(delay2.signal && boxLED2){
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
    delay1.setHour,
    DELAY_SET1_X,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    delay1.setMinute,
    DELAY_SET1_X + TIME_SET_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    delay1.setSecond,
    DELAY_SET1_X + TIME_SET_HORIZ_OFFSET*2,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );

  // Numbers for displaying the timer
  text(
    delay1.timerH,
    DELAY_SET1_X + TIME_SHOW_HORIZ_START_OFFSET,
    DELAY_SET_Y + TIME_SHOW_VERT_OFFSET
  );
  text(
    delay1.timerM,
    DELAY_SET1_X
    + TIME_SHOW_HORIZ_START_OFFSET
    + TIME_SHOW_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SHOW_VERT_OFFSET
  );
  text(
    delay1.timerS,
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
    delay2.setHour,
    DELAY_SET2_X,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    delay2.setMinute,
    DELAY_SET2_X + TIME_SET_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    delay2.setSecond,
    DELAY_SET2_X + TIME_SET_HORIZ_OFFSET*2,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );

  // Numbers for displaying the timer
  text(
    delay2.timerH,
    DELAY_SET2_X + TIME_SHOW_HORIZ_START_OFFSET,
    DELAY_SET_Y + TIME_SHOW_VERT_OFFSET
  );
  text(
    delay2.timerM,
    DELAY_SET2_X
    + TIME_SHOW_HORIZ_START_OFFSET
    + TIME_SHOW_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SHOW_VERT_OFFSET
  );
  text(
    delay2.timerS,
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
    delay1.activate(
      delay1.setHour,
      delay1.setMinute,
      delay1.setSecond
    );
  }
  if (hourUpButton1.buttonOver) {
    delay1.setHour = hourUpButton1.increase(delay1.setHour);
  }
  if (hourDownButton1.buttonOver) {
    delay1.setHour = hourDownButton1.decrease(delay1.setHour);
  }
  if (minuteUpButton1.buttonOver) {
    delay1.setMinute = minuteUpButton1.increase(delay1.setMinute);
    if (delay1.setMinute == 60) {
      delay1.setMinute = 0;
    }
  }
  if (minuteDownButton1.buttonOver) {
    delay1.setMinute = minuteDownButton1.decrease(delay1.setMinute);
  }
  if (secondUpButton1.buttonOver) {
    delay1.setSecond = secondUpButton1.increase(delay1.setSecond);
    if (delay1.setSecond == 60) {
      delay1.setSecond = 0;
    }
  }
  if (secondDownButton1.buttonOver) {
    delay1.setSecond = secondDownButton1.decrease(delay1.setSecond);
  }

  //----------------------------------------------------------------------------
  //Delay For First Pressure Pad
  if (delayButton2.buttonOver) {
    delay2.activate(
      delay2.setHour,
      delay2.setMinute,
      delay2.setSecond
    );
  }
  if (hourUpButton2.buttonOver) {
    delay2.setHour = hourUpButton2.increase(delay2.setHour);
  }
  if (hourDownButton2.buttonOver) {
    delay2.setHour = hourDownButton1.decrease(delay2.setHour);
  }
  if (minuteUpButton2.buttonOver) {
    delay2.setMinute = minuteUpButton2.increase(delay2.setMinute);
    if (delay2.setMinute == 60) {
      delay2.setMinute = 0;
    }
  }
  if (minuteDownButton2.buttonOver) {
    delay2.setMinute = minuteDownButton1.decrease(delay2.setMinute);
  }
  if (secondUpButton2.buttonOver) {
    delay2.setSecond = secondUpButton2.increase(delay2.setSecond);
    if (delay2.setSecond == 60) {
      delay2.setSecond = 0;
    }
  }
  if (secondDownButton2.buttonOver) {
    delay2.setSecond = secondDownButton2.decrease(delay2.setSecond);
  }
}

// This private method initializes the first delay set at the
// given coordinates.
//
// A delay set includes 6 buttons for incrementing/decrementing the amount
// of time to delay, 1 button for activating a delay, and two sets of times
// (one for setting the delay timer, one for the active delay timer).
private void initializeDelaySet1(final int x, final int y) {

  hourUpButton1 = new UpButton(
    x, y,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  hourDownButton1 = new DownButton(
    x, y + ARROW_BUTTON_VERT_OFFSET,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  minuteUpButton1 = new UpButton(
    x + ARROW_BUTTON_HORIZ_OFFSET, y,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  minuteDownButton1 = new DownButton(
    x + ARROW_BUTTON_HORIZ_OFFSET, y + ARROW_BUTTON_VERT_OFFSET,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  secondUpButton1 = new UpButton(
    x + ARROW_BUTTON_HORIZ_OFFSET*2, y,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  secondDownButton1 = new DownButton(
    x + ARROW_BUTTON_HORIZ_OFFSET*2, y + ARROW_BUTTON_VERT_OFFSET,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );

  delayButton1 = new DelayButton(
    x + DELAY_BUTTON_HORIZ_OFFSET, y + DELAY_BUTTON_VERT_OFFSET,
    DELAY_BUTTON_WIDTH, DELAY_BUTTON_HEIGHT
  );

  delay1 = new Delay();

}

// This private method initializes the second delay set at the
// given coordinates.
//
// A delay set includes 6 buttons for incrementing/decrementing the amount
// of time to delay, 1 button for activating a delay, and two sets of times
// (one for setting the delay timer, one for the active delay timer).
private void initializeDelaySet2(final int x, final int y) {

  hourUpButton2 = new UpButton(
    x, y,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  hourDownButton2 = new DownButton(
    x, y + ARROW_BUTTON_VERT_OFFSET,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  minuteUpButton2 = new UpButton(
    x + ARROW_BUTTON_HORIZ_OFFSET,
    y,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  minuteDownButton2 = new DownButton(
    x + ARROW_BUTTON_HORIZ_OFFSET, y + ARROW_BUTTON_VERT_OFFSET,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  secondUpButton2 = new UpButton(
    x + ARROW_BUTTON_HORIZ_OFFSET*2, y,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );
  secondDownButton2 = new DownButton(
    x + ARROW_BUTTON_HORIZ_OFFSET*2, y + ARROW_BUTTON_VERT_OFFSET,
    ARROW_BUTTON_SIZE, ARROW_BUTTON_SIZE
  );

  delayButton2 = new DelayButton(
    x + DELAY_BUTTON_HORIZ_OFFSET, y + DELAY_BUTTON_VERT_OFFSET,
    DELAY_BUTTON_WIDTH, DELAY_BUTTON_HEIGHT
  );

  delay2 = new Delay();

}

// This private method receives input from the Arduino until the first
// newline character if available. If no input is received, then null
// is returned.
private String receiveFromArduino() {

  String val = null;

  if ( !(port.available() > 0) ) {
    return val;
  }

  val = port.readStringUntil('\n');

  if(val != null){
    val = trim(val);  // Remove excess whitespace at beginning/end

    padPower = val.equals("20");

    padLED1 = (val.charAt(0) == '1');
    boxLED1 = padLED1;

    padLED2 = (val.charAt(1) == '1');
    boxLED2 = padLED1;
  }

  return val;
}

// This private method receives a String representing the input from the
// Arduino and sets the boolean variables representing the Arduino LEDs.
private void setArduinoStatus(String val) {

  padPower = val.equals("20");

  padLED1 = (val.charAt(0) == '1');
  boxLED1 = padLED1;

  padLED2 = (val.charAt(1) == '1');
  boxLED2 = padLED1;

}

// This private method sends the status of the delay to the Arduino
// as two characters and a newline, representing the first delay set
// and the second delay set respectively.
//
// If a character is 1, then the delay is active.
// If a character is 0, then the delay is not active.
private void sendArduinoDelaySignal() {

  char sendVal1;
  char sendVal2;

  if(delay1.signal) {
    sendVal1 = '1';
  }
  else {
    sendVal1 = '0';
  }

  if(delay2.signal) {
    sendVal2 = '1';
  }
  else {
    sendVal2 = '0';
  }

  port.write(sendVal1);
  port.write(sendVal2);
  port.write("\n");

}
