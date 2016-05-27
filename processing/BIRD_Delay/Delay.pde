class Delay {
  boolean signal;
  boolean on;

  int timerH;
  int timerM;
  int timerS;
  int counter;

  // Manipulated by the user through BIRD_Delay to set a delay time
  int setHour = 0;
  int setMinute = 0;
  int setSecond = 0;

  Delay() {
    timerH = 0;
    timerM = 0;
    timerS = 0;
    counter = 59;
    signal = true;
    on = false;
  }

  void update() {
    if (!on) {
      return;
    }

    if (timerS > 0 || timerM > 0 || timerH > 0){
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
    if (timerM <= 0){
      timerH--;
      timerM = 59;
    }
    if (timerH < 0) {
      timerH = 0;
    }

    if (timerS <= 0 && timerM <= 0 && timerH <= 0){
      on = false;
      signal = true;
      timerS = 0;
      timerM = 0;
      timerH = 0;
      counter = 0;
    }

  }

  void activate(int h, int m, int s) {
    on = true;
    signal = false;
    timerH = h;
    timerM = m;
    timerS = s;
    counter = 59;
  }

}
