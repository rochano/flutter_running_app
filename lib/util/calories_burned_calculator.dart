class CaloriesBurnedCalculator {
  double weight;
  int hours;
  int minutes;
  int seconds;
  double distance;

  CaloriesBurnedCalculator(
      this.weight, this.hours, this.minutes, this.seconds, this.distance);

  double calcCaloriesBurned() {
    if (hours > 0) {
      minutes = minutes + (hours * 60);
    }
    if (seconds > 0) {
      minutes = (minutes + (seconds / 60)).round();
    }
    double met = getMetByUnknownSpeed(minutes);
    double calories = calcKg(weight, met, minutes);
    return calories;
  }

  double getMetByUnknownSpeed(int minutes) {
    double met = -1;
    double speed = closestSpeed(((distance / minutes)*60)*0.621371192);
    switch (speed.toString()) {
      case '4': met = 6; break;
      case '5': met = 8.3; break;
      case '5.5': met = 9; break;
      case '6': met = 9.8; break;
      case '6.5': met = 10.5; break;
      case '7': met = 11; break;
      case '7.5': met = 11.4; break;
      case '8': met = 11.8; break;
      case '8.5': met = 12.3; break;
      case '9': met = 12.8; break;
      case '10': met = 14.5; break;
      case '11': met = 16; break;
      case '12': met = 19; break;
      case '13': met = 19.8; break;
      default: met = 23; break;
    }
    return met;
  }

  double closestSpeed(double num) {
    List<double> knowSpeeds = [4,5,5.5,6,6.5,7,7.5,8,8.5,9,10,11,12,13,14];
    double current = knowSpeeds[0];
    double diff = (num - current).abs();
    for (int i = 0; i < knowSpeeds.length; i++) {
      double newDiff = (num - knowSpeeds[i]);
      if (newDiff < diff) {
        diff = newDiff;
        current = knowSpeeds[i];
      }
    }
    return current;
  }

  double calcKg(double weight, double met, int minutes) {
    return met * 3.5 * weight / 200 * minutes;
  }
}
