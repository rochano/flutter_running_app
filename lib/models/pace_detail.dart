class PaceDetail {
  int paceId;
  int trackId;
  double distance;
  double pace;

  PaceDetail({this.paceId, this.trackId, this.distance, this.pace});

  factory PaceDetail.fromJson(Map<String, dynamic> json) => PaceDetail(
        paceId: int.parse(json["paceId"].toString()),
        distance: double.parse(json["distance"].toString()),
        pace: double.parse(json["pace"].toString()),
      );

  Map<String, dynamic> toJson() =>
      {"paceId": paceId, "distance": distance, "pace": pace};
}

// List<PaceDetail> paceList = [
//   // 1
//   PaceDetail(paceId:1, trackId: 1, distance: 0.1, pace: 9.25),
//   PaceDetail(paceId:2, trackId: 1, distance: 0.2, pace: 9.23),
//   PaceDetail(paceId:3, trackId: 1, distance: 0.4, pace: 9.20),
//   PaceDetail(paceId:4, trackId: 1, distance: 0.5, pace: 9.19),
//   PaceDetail(paceId:5, trackId: 1, distance: 0.3, pace: 9.21),
//   PaceDetail(paceId:6, trackId: 1, distance: 0.6, pace: 9.17),
//   PaceDetail(paceId:7, trackId: 1, distance: 0.7, pace: 9.15),
//   PaceDetail(paceId:8, trackId: 1, distance: 0.8, pace: 9.12),
//   PaceDetail(paceId:9, trackId: 1, distance: 0.9, pace: 9.10),
//   // 2
//   PaceDetail(paceId:10, trackId: 2, distance: 2.0, pace: 7.30),
//   // 3
//   PaceDetail(paceId:11, trackId: 3, distance: 3.0, pace: 7.18),
//   // 4
//   PaceDetail(paceId:12, trackId: 4, distance: 4.0, pace: 8.25),
//   PaceDetail(paceId:13, trackId: 5, distance: 4.5, pace: 8.11),
// ];
