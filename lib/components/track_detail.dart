import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/models/pace_detail.dart';
import 'package:running_app/models/track.dart';

class TrackDetail extends StatelessWidget {
  final Track currentTrack;

  const TrackDetail({Key key, this.currentTrack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Track Detail",
          ),
        ),
        body: TrackDetailContent(track: currentTrack));
  }
}

class TrackDetailContent extends StatelessWidget {
  final Track track;
  const TrackDetailContent({
    Key key,
    this.track,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScrollView(
      physics: ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            width: size.width,
            decoration: BoxDecoration(color: Colors.greenAccent),
            child: track.imageBytes != null
                ? Image.memory(track.imageBytes)
                : null,
          ),
        ),
        TrackItem(
          size: size,
          title: "Distances",
          value: "${NumberFormat('#0.00').format(track.distance)} KM.",
        ),
        TrackItem(
          size: size,
          title: "Pace",
          value: "${track.pace.round()}",
        ),
        TrackItem(
          size: size,
          title: "Burn",
          value: "${NumberFormat('#,###').format(track.calories)} Calories",
        ),
        TrackItem(
          size: size,
          title: "Date",
          value: "${track.getDateFormat()}",
        ),
        TrackItem(
          size: size,
          title: "Duration",
          value: "${track.getDurationFormat()} Hours",
        ),
        TrackItem(
          size: size,
          title: "Avg. Step",
          value: "${track.avgStep}  step/min.",
        ),
        TrackItem(
          size: size,
          title: "Max Step",
          value: "${track.maxStep}  step/min.",
        ),
        TrackItem(
          size: size,
          title: "Avg. Heart Rate",
          value: "*** ${track.avgHeartRt} time/min.",
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          sliver: SliverToBoxAdapter(
            child: Container(
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: LineChart(
                        LineChartData(
                            minY: getMinPace(track.paceList).toInt() - 1.0,
                            maxY: getMaxPace(track.paceList).toInt() + 1.0,
                            titlesData: FlTitlesData(
                              bottomTitles: SideTitles(
                                  margin: 10.0,
                                  showTitles: true,
                                  getTitles: (double value) {
                                    String sText =
                                        value.toInt().toString() + ".0";
                                    if (value ==
                                        track
                                            .paceList[track.paceList.length - 1]
                                            .distance) {
                                      sText = value.toString();
                                    }
                                    if (double.parse(sText) == 0) {
                                      sText = "";
                                    }
                                    return sText;
                                  }),
                              leftTitles: SideTitles(
                                showTitles: true,
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: track.paceList
                                    .map((pace) => FlSpot(
                                          pace.distance,
                                          pace.pace,
                                        ))
                                    .toList(),
                                isCurved: true,
                                colors: const [
                                  kPrimaryColor,
                                ],
                                // barWidth: 8,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: false,
                                ),
                                // belowBarData: BarAreaData(
                                //   show: false,
                                // ),
                              )
                            ]),
                      )),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  double getMinPace(List<PaceDetail> paces) {
    PaceDetail minPace =
        paces.reduce((curr, next) => curr.pace < next.pace ? curr : next);
    return minPace.pace;
  }

  double getMaxPace(List<PaceDetail> paces) {
    PaceDetail maxPace =
        paces.reduce((curr, next) => curr.pace > next.pace ? curr : next);
    return maxPace.pace;
  }
}

class TrackItem extends StatelessWidget {
  final String title;
  final String value;
  const TrackItem({
    Key key,
    @required this.size,
    this.title,
    this.value,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 0),
        // decoration: BoxDecoration(color: Colors.orange),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding,
              vertical: kDefaultVerticalPadding),
          child: Row(
            children: <Widget>[
              Container(
                width: size.width * 0.5,
                child: RichText(
                  text: TextSpan(
                    text: title,
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                      text: value,
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
