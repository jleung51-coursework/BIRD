/*
 * This Processing file runs an application which shows the status of The
 * BIRD system and allows the user to delay the car alert by a given amount
 * of time.
 *
 */

import processing.serial.*;

private Serial port;

private UpButton hourUpButton1;
private UpButton hourUpButton2;
private DownButton hourDownButton1;
private DownButton hourDownButton2;

private UpButton minuteUpButton1;
private UpButton minuteUpButton2;
private DownButton minuteDownButton1;
private DownButton minuteDownButton2;

private UpButton secondUpButton1;
private UpButton secondUpButton2;
private DownButton secondDownButton1;
private DownButton secondDownButton2;

private DelayButton delayButton1;
private DelayButton delayButton2;
private Delay delay1;
private Delay delay2;

private Pad ppad;
private Box cbox;

private boolean padPower;
private boolean padLED1;
private boolean padLED2;
private boolean boxLED1;
private boolean boxLED2;

// Text
private static final String TEXT_HOURS = "Hours";
private static final String TEXT_MINUTES = "Minutes";
private static final String TEXT_SECONDS = "Seconds";
private static final String TEXT_TITLE = "BIRD Delay";
private static final String TEXT_DELAY_SET1_TITLE = "Essential Pad";
private static final String TEXT_DELAY_SET2_TITLE = "Other Pad";

// Pad/Box locations
private static final int BOX_X = 860;
private static final int BOX_Y = 550;

// Delay-set locations
private static final int DELAY_SET1_X = 30;
private static final int DELAY_SET2_X = 542;
private static final int DELAY_SET_Y = 150;

// Button sizes
private static final int ARROW_BUTTON_SIZE = 30;
private static final int DELAY_BUTTON_WIDTH = 80;
private static final int DELAY_BUTTON_HEIGHT = 40;

// Text sizes
private static final int TEXT_SIZE_TIMER = 25;
private static final int TEXT_SIZE_TITLE = 40;
private static final int TEXT_SIZE_DELAY_SET_TITLES = 30;

// Button offsets
private static final int ARROW_BUTTON_HORIZ_OFFSET = 150;
private static final int ARROW_BUTTON_VERT_OFFSET = 80;
private static final int DELAY_BUTTON_HORIZ_OFFSET = 180;
private static final int DELAY_BUTTON_VERT_OFFSET = 140;

// Number offsets
private static final int TIME_SET_HORIZ_OFFSET = ARROW_BUTTON_HORIZ_OFFSET;
private static final int TIME_SET_VERT_OFFSET = 65;
private static final int TIME_SHOW_HORIZ_START_OFFSET = 160;
private static final int TIME_SHOW_HORIZ_OFFSET = 50;
private static final int TIME_SHOW_VERT_OFFSET = 230;

// Text offsets
private static final int TIME_SET_TEXT_HORIZ_START_OFFSET = 40;
private static final int TIME_SET_TEXT_HORIZ_OFFSET = TIME_SET_HORIZ_OFFSET;
private static final int TITLE_HORIZ_OFFSET = 450;
private static final int TITLE_VERT_OFFSET = 65;
private static final int DELAY_SET1_TITLE_HORIZ_OFFSET = 155;
private static final int DELAY_SET2_TITLE_HORIZ_OFFSET = 680;
private static final int DELAY_SET_TITLE_VERT_OFFSET = 120;

// Colors
private final color COLOR_GREY_DARK = color(128);
private final color COLOR_WHITE = color(255);
private final color COLOR_BACKGROUND = COLOR_GREY_DARK;
private final color COLOR_TEXT = COLOR_WHITE;

public void setup() {
  size (1024,768);

  port = new Serial(this, "/dev/ttyUSB0", 9600);

  initializeDelaySet1(DELAY_SET1_X, DELAY_SET_Y);
  initializeDelaySet2(DELAY_SET2_X, DELAY_SET_Y);
  ppad = new Pad();
  cbox = new Box(BOX_X, BOX_Y);
}

public void draw() {
  background(COLOR_BACKGROUND);

  String arduinoInput = receiveFromArduino();
  if(arduinoInput != null) {
    setArduinoStatus(arduinoInput);
    sendArduinoDelaySignal();
  }

  ppad.update(padLED1, padPower, padLED2);

  //----------------------------------------------------------------------------
  // Update delay for pressure pad 1
  hourUpButton1.update(mouseX, mouseY);
  hourDownButton1.update(mouseX, mouseY);
  minuteUpButton1.update(mouseX, mouseY);
  minuteDownButton1.update(mouseX, mouseY);
  secondUpButton1.update(mouseX, mouseY);
  secondDownButton1.update(mouseX, mouseY);
  delayButton1.update(mouseX, mouseY);

  delay1.update();

  //----------------------------------------------------------------------------
  // Update delay for pressure pad 2
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
  ppad.setPad1On(padLED1);
  ppad.setPowerOn(padPower);
  ppad.setPad2On(padLED2);

  cbox.setLED1On(delay1.getSignal() && boxLED1);
  cbox.setPowerOn(true);
  cbox.setLED1On(delay2.getSignal() && boxLED2);

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
    delay1.getHour(),
    DELAY_SET1_X,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    delay1.getMinute(),
    DELAY_SET1_X + TIME_SET_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    delay1.getSecond(),
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
    DELAY_SET1_X + TIME_SET_TEXT_HORIZ_START_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    TEXT_MINUTES,
    DELAY_SET1_X
    + TIME_SET_TEXT_HORIZ_START_OFFSET
    + TIME_SET_TEXT_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    TEXT_SECONDS,
    DELAY_SET1_X
    + TIME_SET_TEXT_HORIZ_START_OFFSET
    + TIME_SET_TEXT_HORIZ_OFFSET*2,
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
    delay2.getHour(),
    DELAY_SET2_X,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    delay2.getMinute(),
    DELAY_SET2_X + TIME_SET_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    delay2.getSecond(),
    DELAY_SET2_X + TIME_SET_HORIZ_OFFSET*2,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );

  // Numbers for displaying the timer
  text(
    delay2.getTimerH(),
    DELAY_SET2_X + TIME_SHOW_HORIZ_START_OFFSET,
    DELAY_SET_Y + TIME_SHOW_VERT_OFFSET
  );
  text(
    delay2.getTimerM(),
    DELAY_SET2_X
    + TIME_SHOW_HORIZ_START_OFFSET
    + TIME_SHOW_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SHOW_VERT_OFFSET
  );
  text(
    delay2.getTimerS(),
    DELAY_SET2_X
    + TIME_SHOW_HORIZ_START_OFFSET
    + TIME_SHOW_HORIZ_OFFSET*2,
    DELAY_SET_Y + TIME_SHOW_VERT_OFFSET
  );

  // Text labels for setting the timer
  text(
    TEXT_HOURS,
    DELAY_SET2_X + TIME_SET_TEXT_HORIZ_START_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    TEXT_MINUTES,
    DELAY_SET2_X
    + TIME_SET_TEXT_HORIZ_START_OFFSET
    + TIME_SET_TEXT_HORIZ_OFFSET,
    DELAY_SET_Y + TIME_SET_VERT_OFFSET
  );
  text(
    TEXT_SECONDS,
    DELAY_SET2_X
    + TIME_SET_TEXT_HORIZ_START_OFFSET
    + TIME_SET_TEXT_HORIZ_OFFSET*2,
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

public void mousePressed() {
  //----------------------------------------------------------------------------
  //Delay For First Pressure Pad
  if (delayButton1.isOverButton()) {
    delay1.activate(
      delay1.getHour(),
      delay1.getMinute(),
      delay1.getSecond()
    );
  }
  if (hourUpButton1.isOverButton()) {
    delay1.setHour(hourUpButton1.increase(delay1.getHour()));
  }
  if (hourDownButton1.isOverButton()) {
    delay1.setHour(hourDownButton1.decrease(delay1.getHour()));
  }
  if (minuteUpButton1.isOverButton()) {
    delay1.setMinute(minuteUpButton1.increase(delay1.getMinute()));
    if (delay1.getMinute() == 60) {
      delay1.setMinute(0);
    }
  }
  if (minuteDownButton1.isOverButton()) {
    delay1.setMinute(minuteDownButton1.decrease(delay1.getMinute()));
  }
  if (secondUpButton1.isOverButton()) {
    delay1.setSecond(secondUpButton1.increase(delay1.getMinute()));
    if (delay1.getSecond() == 60) {
      delay1.setSecond(0);
    }
  }
  if (secondDownButton1.isOverButton()) {
    delay1.setSecond(secondDownButton1.decrease(delay1.getSecond()));
  }

  //----------------------------------------------------------------------------
  //Delay For First Pressure Pad
  if (delayButton2.isOverButton()) {
    delay2.activate(
      delay2.getHour(),
      delay2.getMinute(),
      delay2.getSecond()
    );
  }
  if (hourUpButton2.isOverButton()) {
    delay2.setHour(hourUpButton2.increase(delay2.getHour()));
  }
  if (hourDownButton2.isOverButton()) {
    delay2.setHour(hourDownButton1.decrease(delay2.getHour()));
  }
  if (minuteUpButton2.isOverButton()) {
    delay2.setMinute(minuteUpButton2.increase(delay2.getMinute()));
    if (delay2.getMinute() == 60) {
      delay2.setMinute(0);
    }
  }
  if (minuteDownButton2.isOverButton()) {
    delay2.setMinute(minuteDownButton1.decrease(delay2.getMinute()));
  }
  if (secondUpButton2.isOverButton()) {
    delay2.setSecond(secondUpButton2.increase(delay2.getSecond()));
    if (delay2.getSecond() == 60) {
      delay2.setSecond(0);
    }
  }
  if (secondDownButton2.isOverButton()) {
    delay2.setSecond(secondDownButton2.decrease(delay2.getSecond()));
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

  String input = null;

  if ( !(port.available() > 0) ) {
    return input;
  }

  input = port.readStringUntil('\n');

  if(input != null){
    input = trim(input);  // Remove excess whitespace at beginning/end
  }

  return input;
}

// This private method receives a String representing the input from the
// Arduino and sets the boolean variables representing the Arduino LEDs.
private void setArduinoStatus(String input) {

  padPower = input.equals("20");

  padLED1 = (input.charAt(0) == '1');
  boxLED1 = padLED1;

  padLED2 = (input.charAt(1) == '1');
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

  if(delay1.getSignal()) {
    sendVal1 = '1';
  }
  else {
    sendVal1 = '0';
  }

  if(delay2.getSignal()) {
    sendVal2 = '1';
  }
  else {
    sendVal2 = '0';
  }

  port.write(sendVal1);
  port.write(sendVal2);
  port.write("\n");

}
