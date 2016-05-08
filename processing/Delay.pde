
class Delay {
  int signal;
  boolean on;
  int hour, minute, second, counter;
  int timerH,timerM,timerS;
  Delay() {
    timerH = 0;
    timerM = 0;
    timerS = 0;
    counter = 59;
    signal = 1;
    on = false;
    hour = 0;
    minute = 0;
    second = 0;
  }

  void update() {
    if (on) {
      if (timerS > 0 || timerM > 0 || timerH > 0){
        counter = counter - 1;
        if (counter == 0) {
          counter = 59;
          timerS = timerS - 1;
          if (timerS == 0 && timerM == 0 && timerH == 0){
            on = false;
            signal = 1;
            timerS = 100;
            counter = 0;
          }
          if (timerS <= 0) {
            timerM = timerM - 1;
            if (timerM <= 0){
              if (timerH > 0) {
                timerH = timerH - 1;
                timerM = 59;
              }
            }
            timerS = 59;
          }
          if (timerS == 100){
            timerS = 0;
            timerM = 0;
            timerH = 0;
          }
        }
      }
    }
  }

  void activate( int h, int m, int s) {
    on = true;
    signal = 0;
    timerH = h;
    timerM = m;
    timerS = s;
    counter = 59;
  }

}
