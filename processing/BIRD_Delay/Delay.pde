/*
 * This Processing class implements a delay object which can be set to
 * a specific delay time, count down, and notify the user when the timer
 * reaches 0.
 *
 */

class Delay {
  boolean active;
  boolean signal;

  int timerH;
  int timerM;
  int timerS;
  int counter;

  // Manipulated by the user through BIRD_Delay to set a delay time
  int setHour = 0;
  int setMinute = 0;
  int setSecond = 0;

  Delay() {
    active = false;
    signal = true;

    timerH = 0;
    timerM = 0;
    timerS = 0;
    counter = 59;
  }

  void update() {
    if (!active) {
      return;
    }

    if (timerS > 0 || timerM > 0 || timerH > 0) {
      counter--;
    }
    else {
      return;
    }

    if (counter <= 0) {
      counter = 59;
      timerS--;
    }
    else {
      return;
    }

    if (timerS <= 0) {
      timerM--;
      timerS = 59;
    }
    if (timerM <= 0) {
      timerH--;
      timerM = 59;
    }
    if (timerH < 0) {
      timerH = 0;
    }

    if (timerS <= 0 && timerM <= 0 && timerH <= 0) {
      active = false;
      signal = true;

      timerH = 0;
      timerM = 0;
      timerS = 0;
      counter = 0;
    }

  }

  void activate(int h, int m, int s) {
    active = true;
    signal = false;

    timerH = h;
    timerM = m;
    timerS = s;
    counter = 59;
  }

}
