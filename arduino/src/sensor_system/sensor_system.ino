/*
 *
 * This Arduino sketch detects the activation of pressure pads by the presence
 * of an item and sends the result using serial communication to the
 * Processing application.
 * If the Processing application responds with an affirmative delay signal,
 * then the result is replaced with the signal for no activation.
 * If the Processing application does not respond or responds with a
 * negative delay signal, then the result is unchanged (therefore,
 * the system is fully functional regardless of the presence of the
 * Processing application).
 * The final result is sent to the car system with serial communication
 * (using pins 2 and 3).
 *
 */

#include <SoftwareSerial.h>

const unsigned int pinPressureEssential = A0;
const unsigned int pinPressureGeneral = A1;
const unsigned int pinCapacitive = A2;

const unsigned int pinPressureEssentialPower = 7;
const unsigned int pinPressureGeneralPower = 6;
const unsigned int pinCapacitivePower = 5;

const unsigned int pinPowerLED = 13;
const unsigned int pinEssentialLED = 12;
const unsigned int pinGeneralLED = 11;

// Calibrated to the individual sensors
const unsigned int thresholdPressureEssential = 700;
const unsigned int thresholdPressureGeneral = 700;
const unsigned int thresholdCapacitive = 200;

// States
bool powerOn = true;
bool powerToggled = false;

// Serial connections
SoftwareSerial serialCarSystem(2, 3);  // Pins 2, 3

// This method returns whether the given input pin reads greater than
// the given threshold.
bool SensorGreaterThan(const unsigned int pin, const unsigned int threshold) {
  return analogRead(pin) > threshold;
}

void setup() {
  Serial.begin(9600);
  serialCarSystem.begin(9600);

  // Pin outputs
  pinMode(pinPressureEssential, INPUT);
  pinMode(pinPressureGeneral, INPUT);

  pinMode(pinPressureEssentialPower, OUTPUT);
  pinMode(pinPressureGeneralPower, OUTPUT);
  pinMode(pinCapacitivePower, OUTPUT);
  digitalWrite(pinPressureEssentialPower, HIGH);
  digitalWrite(pinPressureGeneralPower, HIGH);
  digitalWrite(pinCapacitivePower, HIGH);

  pinMode(pinPowerLED, OUTPUT);
  pinMode(pinEssentialLED, OUTPUT);
  pinMode(pinGeneralLED, OUTPUT);
  digitalWrite(pinPowerLED, HIGH);
  digitalWrite(pinEssentialLED, LOW);
  digitalWrite(pinGeneralLED, LOW);
}

void loop() {
  delay(300);

  // Power on/off
  if(!SensorGreaterThan(pinCapacitive, thresholdCapacitive) &&
     !powerToggled) {
    powerOn = !powerOn;
    powerToggled = true;
  }

  // Does not allow power to be repeatedly toggled if the capacitive
  // sensor is constantly contacted
  else if(SensorGreaterThan(pinCapacitive, thresholdCapacitive)) {
    powerToggled = false;
  }

  digitalWrite(pinPowerLED, LOW);
  digitalWrite(pinEssentialLED, LOW);
  digitalWrite(pinGeneralLED, LOW);

  char c0 = '0';
  char c1 = '0';
  if(powerOn) {
    digitalWrite(pinPowerLED, HIGH);

    if(!SensorGreaterThan(pinPressureEssential, thresholdPressureEssential)) {
      digitalWrite(pinEssentialLED, HIGH);
      c0 = '1';
    }
    if(!SensorGreaterThan(pinPressureGeneral, thresholdPressureGeneral)) {
      digitalWrite(pinGeneralLED, HIGH);
      c1 = '1';
    }

    // Signaling power on to Processing
    Serial.println("20");
  }
  else {
    // Signaling power off to Processing
    Serial.println("21");
  }

  Serial.write(c0);
  Serial.write(c1);
  Serial.write('\n');

  delay(100);
  if(Serial.available()) {
    String in = Serial.readStringUntil('\n');
    if(in.charAt(0) == '0') {
      c0 = '0';
    }
    if(in.charAt(1) == '0') {
      c1 = '0';
    }
  }

  if(c0 == '0' && c1 == '0') {
    serialCarSystem.println("00");
  }
  else if(c0 == '0' && c1 == '1') {
    serialCarSystem.println("01");
  }
  else if(c0 == '1' && c1 == '0') {
    serialCarSystem.println("10");
  }
  else if(c0 == '1' && c1 == '1') {
    serialCarSystem.println("11");
  }
}
