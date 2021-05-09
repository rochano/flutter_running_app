import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/models/Challenge.dart';
import 'package:http/http.dart' as http;
import 'package:running_app/screens/screen.dart';

class ChallengeList extends StatelessWidget {
  Future<List<Challenge>> getChallenges() async {
    var data = await http.get(baseUrl + '/getallchallenges');
    var jsonData = json.decode(data.body);

    List<Challenge> challenges = [];
    for (var elm in jsonData) {
      Challenge challenge = Challenge.fromJson(elm);
      challenges.add(challenge);
    }
    return challenges;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            "CHALLENGE",
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChallengeDetail()));
              },
            ),
          ],
        ),
        body: Container(
          child: FutureBuilder(
            future: getChallenges(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => ChallengeContent(
                        challenge: snapshot.data[index],
                      ));
            },
          ),
        ));
  }
}

class ChallengeContent extends StatelessWidget {
  final Challenge challenge;
  const ChallengeContent({Key key, this.challenge}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Duration\n",
                        style: TextStyle(
                            color: kTextColor, fontSize: 14, height: 1.5),
                      ),
                      TextSpan(
                        text: "Distances",
                        style: TextStyle(
                            color: kTextColor, fontSize: 14, height: 1.5),
                      ),
                    ]),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(children: [
                        TextSpan(
                            text:
                                "${challenge.getBeginDateFormat()} - ${challenge.getEndDateFormat()}\n",
                            style: TextStyle(
                                color: kTextColor, fontSize: 14, height: 1.5)),
                        TextSpan(
                          text:
                              "${NumberFormat('0.00').format(challenge.currentDistance)} / ${NumberFormat('0.00').format(challenge.targetDistance)} KM.",
                          style: TextStyle(
                              color: kTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )
                      ]),
                    ),
                  ),
                )
              ],
            ),
            Container(
                padding: EdgeInsets.only(top: kDefaultVerticalPadding),
                width: MediaQuery.of(context).size.width * 0.90,
                child: LinearProgressIndicator(
                  minHeight: 8,
                  backgroundColor: Color(0XFFCCCCCC),
                  value: challenge.getDistanceRate(),
                  //valueColor: new AlwaysStoppedAnimation<Color>(Color(0XFF3366CC)),
                ))
          ],
        ),
      ),
    );
  }
}
