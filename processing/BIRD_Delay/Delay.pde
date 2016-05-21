class Delay {
  int signal;
  boolean on;

  int hour;
  int minute;
  int second;
  int counter;

  int timerH;
  int timerM;
  int timerS;

  Delay() {
    timerH = 0;
    timerM = 0;
    timerS = 0;
    counter = 59;
    signal = 1;
    on = false;
    hour = 0;
    second = 0;
    minute = 0;
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
      signal = 1;
      timerS = 0;
      timerM = 0;
      timerH = 0;
      counter = 0;
    }

  }

  void activate(int h, int m, int s) {
    on = true;
    signal = 0;
    timerH = h;
    timerM = m;
    timerS = s;
    counter = 59;
  }

}
