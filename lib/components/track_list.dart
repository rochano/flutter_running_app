import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/models/track.dart';
import 'package:running_app/providers/provider.dart';
import 'package:running_app/screens/screen.dart';

class TrackList extends StatefulWidget {
  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Track",
        ),
        leading: Container(),
      ),
      body: Container(
          child: FutureBuilder(
              future: Provider.of<TrackProvider>(context, listen: false)
                  .fetchAndSetTracks(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return Consumer<TrackProvider>(
                  builder: (context, trackData, child) => ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: trackData.tracks.length,
                      itemBuilder: (context, index) => TrackContent(
                          track: trackData.tracks[index],
                          press: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TrackDetail(
                                  currentTrack: trackData.tracks[index],
                                ),
                              )))),
                );
              })),
    );
  }
}

class TrackContent extends StatelessWidget {
  final Track track;
  final Function press;
  const TrackContent({
    Key key,
    this.track,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        margin: EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        // decoration: BoxDecoration(
        //     color: Colors.orange,
        //     boxShadow: [
        //       BoxShadow(
        //           color: Colors.grey.withOpacity(0.1), offset: Offset(0, 10))
        //     ],
        //     borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text:
                        "${NumberFormat('0.00').format(track.distance)} KM.\n",
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: "${track.getDateFormat()}",
                    style:
                        TextStyle(color: kTextColor, fontSize: 14, height: 1.5),
                  )
                ])),
              ),
              // Expanded(
              //   child: Container(
              //       alignment: Alignment.center,
              //       child: Container(
              //         alignment: Alignment.center,
              //         padding: EdgeInsets.all(8.0),
              //         width: 120,
              //         decoration: BoxDecoration(
              //             color: Colors.blue[200],
              //             borderRadius: BorderRadius.circular(20)),
              //         child: Text(
              //           "PACE ${track.pace}",
              //           style: TextStyle(
              //               color: kTextColor,
              //               fontSize: 22,
              //               fontWeight: FontWeight.w600),
              //         ),
              //       )),
              // ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(children: [
                      TextSpan(
                        text:
                            "${NumberFormat('#,###').format(track.calories)} Calories\n",
                        style: TextStyle(
                            color: kTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: "${track.getDurationFormat()} Hours",
                        style: TextStyle(
                            color: kTextColor, fontSize: 14, height: 1.5),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
