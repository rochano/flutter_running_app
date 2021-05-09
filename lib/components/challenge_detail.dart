import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/models/challenge.dart';
import 'package:running_app/util/string_util.dart';
import 'package:running_app/widget/challenge_expansion_panel.dart';
import 'package:http/http.dart' as http;

class ChallengeDetail extends StatefulWidget {
  @override
  _ChallengeDetailState createState() => _ChallengeDetailState();
}

class _ChallengeDetailState extends State<ChallengeDetail> {
  DateTime _selectedBeginDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  double _selectedDistance = 0.00;

  void registerChallenge() async {
    // print(
    //     "_selectedBeginDate: ${_selectedBeginDate}\_selectedEndDate: ${_selectedEndDate}\_selectedDistance: ${_selectedDistance}\n");
    Challenge challenge = new Challenge(
      // challengeId: 1,
      beginDate: StringUtils.convertDateToString(_selectedBeginDate),
      endDate: StringUtils.convertDateToString(_selectedEndDate),
      targetDistance: _selectedDistance,
    );

    await http.post(baseUrl + '/addchallenge',
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(challenge.toJson()));

    // display list
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<ChallengeItem> children = <ChallengeItem>[
      ChallengeItem(
          id: 0,
          title: "Begin Date",
          value: DateFormat.yMMMEd().format(_selectedBeginDate),
          callback: (DateTime newdate) {
            setState(() {
              _selectedBeginDate = newdate;
            });
          }),
      ChallengeItem(
          id: 1,
          title: "End Date",
          value: DateFormat.yMMMEd().format(_selectedEndDate),
          callback: (DateTime newdate) {
            setState(() {
              _selectedEndDate = newdate;
            });
          }),
      ChallengeItem(
          id: 2,
          title: "Distances",
          value: "${NumberFormat('0.00').format(_selectedDistance)}  KM.",
          callback: (double distance) {
            setState(() {
              _selectedDistance = distance;
            });
          }),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "CHALLENGE DETAIL",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: registerChallenge,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ChallengeExpansionPanelList(
          children: children,
        ),
      ),
    );
  }
}
