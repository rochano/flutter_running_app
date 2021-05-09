import 'package:intl/intl.dart';

class Challenge {
  int challengeId;
  String beginDate;
  String endDate;
  double targetDistance;
  double currentDistance;

  Challenge(
      {this.challengeId,
      this.beginDate,
      this.endDate,
      this.targetDistance,
      this.currentDistance});

  String getBeginDateFormat() {
    int y = int.parse(beginDate.substring(0, 4));
    int m = int.parse(beginDate.substring(4, 6));
    int d = int.parse(beginDate.substring(6, 8));
    return DateFormat.yMMMd().format(new DateTime(y, m, d));
  }

  String getEndDateFormat() {
    int y = int.parse(endDate.substring(0, 4));
    int m = int.parse(endDate.substring(4, 6));
    int d = int.parse(endDate.substring(6, 8));
    return DateFormat.yMMMd().format(new DateTime(y, m, d));
  }

  double getDistanceRate() {
    return targetDistance == 0 ? 0 : currentDistance / targetDistance;
  }

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        challengeId: int.parse(json["challengeId"].toString()),
        beginDate: json["beginDate"],
        endDate: json["endDate"],
        targetDistance: double.parse(json["targetDistance"].toString()),
        currentDistance: double.parse(json["currentDistance"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "challengeId": challengeId,
        "beginDate": beginDate,
        "endDate": endDate,
        "targetDistance": targetDistance,
        "currentDistance": currentDistance,
      };
}
