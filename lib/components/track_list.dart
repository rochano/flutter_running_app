import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/models/track.dart';
import 'package:http/http.dart' as http;
import 'package:running_app/screens/screen.dart';

class TrackList extends StatelessWidget {
  Future<List<Track>> getTracks() async {
    var data = await http.get(baseUrl + '/getalltracks');
    var jsonData = json.decode(data.body);

    List<Track> tracks = [];
    for (var elm in jsonData) {
      Track track = Track.fromJson(elm);
      tracks.add(track);
    }
    return tracks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "TRACK",
        ),
      ),
      body: Container(
          child: FutureBuilder(
              future: getTracks(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => TrackContent(
                        track: snapshot.data[index],
                        press: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrackDetail(
                                currentTrack: snapshot.data[index],
                              ),
                            ))));
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
                        fontWeight: FontWeight.w600),
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
