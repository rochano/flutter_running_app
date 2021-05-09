import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:running_app/models/pace_detail.dart';

class Track {
  int trackId;
  String image;
  double distance;
  double calories;
  double pace;
  String date;
  String duration;
  int avgStep;
  int maxStep;
  int avgHeartRt;
  Uint8List imageBytes;
  List<PaceDetail> paceList;

  Track({
    this.trackId,
    this.image,
    this.distance,
    this.calories,
    this.pace,
    this.date,
    this.duration,
    this.avgStep,
    this.maxStep,
    this.avgHeartRt,
    this.imageBytes,
    this.paceList,
  });

  String getDateFormat() {
    int y = int.parse(date.substring(0, 4));
    int m = int.parse(date.substring(4, 6));
    int d = int.parse(date.substring(6, 8));
    return DateFormat.yMMMd().format(new DateTime(y, m, d));
  }

  String getDurationFormat() {
    return duration.substring(0, 2) + ":" + duration.substring(2, 4);
  }

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        trackId: int.parse(json["trackId"].toString()),
        distance: double.parse(json["distance"].toString()),
        calories: double.parse(json["calories"].toString()),
        pace: double.parse(json["pace"].toString()),
        date: json["date"],
        duration: json["duration"],
        avgStep: int.parse(json["avgStep"].toString()),
        maxStep: int.parse(json["maxStep"].toString()),
        avgHeartRt: int.parse(json["avgHeartRt"].toString()),
        paceList: List.of(json["paceList"])
            .map((e) => PaceDetail.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "trackId": trackId,
        "distance": distance,
        "calories": calories,
        "pace": pace,
        "date": date,
        "duration": duration,
        "avgStep": avgStep,
        "maxStep": maxStep,
        "avgHeartRt": avgHeartRt,
        "paceList": paceList.map((e) => e.toJson()).toList()
      };
}

// List<Track> tracks = [
//   Track(
//     trackId: 1,
//     image: "",
//     distance: 10.01,
//     calories: 503,
//     pace: 8,
//     date: "20200120",
//     duration: "005033",
//     avgStep: 275,
//     maxStep: 560,
//     avgHeartRt: 120,
//     paceList: paceList,
//   ),
//   Track(
//     trackId: 2,
//     image: "",
//     distance: 40.53,
//     calories: 359,
//     pace: 8,
//     date: "20200125",
//     duration: "004526",
//     avgStep: 275,
//     maxStep: 560,
//     avgHeartRt: 111,
//     paceList: paceList,
//   ),
//   Track(
//     trackId: 3,
//     image: "",
//     distance: 35.67,
//     calories: 266,
//     pace: 9,
//     date: "20200203",
//     duration: "003533",
//     avgStep: 275,
//     maxStep: 560,
//     avgHeartRt: 115,
//     paceList: paceList,
//   ),
//   Track(
//     trackId: 4,
//     image: "",
//     distance: 34.67,
//     calories: 266,
//     pace: 9,
//     date: "20200304",
//     duration: "003533",
//     avgStep: 275,
//     maxStep: 560,
//     avgHeartRt: 98,
//     paceList: paceList,
//   ),
//   Track(
//     trackId: 5,
//     image: "",
//     distance: 35.67,
//     calories: 266,
//     pace: 6,
//     date: "20200405",
//     duration: "003533",
//     avgStep: 275,
//     maxStep: 560,
//     avgHeartRt: 105,
//     paceList: paceList,
//   ),
//   Track(
//     trackId: 6,
//     image: "",
//     distance: 36.67,
//     calories: 266,
//     pace: 7,
//     date: "20200506",
//     duration: "003533",
//     avgStep: 275,
//     maxStep: 560,
//     avgHeartRt: 99,
//     paceList: paceList,
//   ),
//   Track(
//     trackId: 7,
//     image: "",
//     distance: 37.67,
//     calories: 266,
//     pace: 10,
//     date: "20200607",
//     duration: "003533",
//     avgStep: 275,
//     maxStep: 560,
//     avgHeartRt: 101,
//     paceList: paceList,
//   ),
//   Track(
//     trackId: 8,
//     image: "",
//     distance: 38.67,
//     calories: 266,
//     pace: 4,
//     date: "20200708",
//     duration: "003533",
//     avgStep: 275,
//     maxStep: 560,
//     avgHeartRt: 110,
//     paceList: paceList,
//   ),
//   Track(
//     trackId: 9,
//     image: "",
//     distance: 39.67,
//     calories: 266,
//     pace: 5,
//     date: "20200809",
//     duration: "003533",
//     avgStep: 275,
//     maxStep: 560,
//     avgHeartRt: 115,
//     paceList: paceList,
//   ),
//   Track(
//     trackId: 10,
//     image: "",
//     distance: 40.67,
//     calories: 266,
//     pace: 9,
//     date: "20200910",
//     duration: "003533",
//     avgStep: 275,
//     maxStep: 560,
//     avgHeartRt: 97,
//     paceList: paceList,
//   ),
//   Track(
//     trackId: 11,
//     image: "",
//     distance: 41.67,
//     calories: 266,
//     pace: 13,
//     date: "20201011",
//     duration: "003533",
//     avgStep: 275,
//     maxStep: 560,
//     avgHeartRt: 115,
//     paceList: paceList,
//   ),
//   Track(
//     trackId: 12,
//     image: "",
//     distance: 42.67,
//     calories: 266,
//     pace: 7,
//     date: "20201112",
//     duration: "003533",
//     avgStep: 275,
//     maxStep: 560,
//     avgHeartRt: 120,
//     paceList: paceList,
//   ),
// ];
