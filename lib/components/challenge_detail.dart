import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/models/challenge.dart';
import 'package:running_app/providers/provider.dart';
import 'package:running_app/util/string_util.dart';
import 'package:running_app/widget/challenge_expansion_panel.dart';

class ChallengeDetail extends StatefulWidget {
  @override
  _ChallengeDetailState createState() => _ChallengeDetailState();
}

class _ChallengeDetailState extends State<ChallengeDetail> {
  DateTime _selectedBeginDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  double _selectedDistance = 0.00;
  var _isLoading = false;

  void registerChallenge() async {
    // print(
    //     "_selectedBeginDate: ${_selectedBeginDate}\_selectedEndDate: ${_selectedEndDate}\_selectedDistance: ${_selectedDistance}\n");
    Challenge challenge = new Challenge(
      // challengeId: 1,
      beginDate: StringUtils.convertDateToString(_selectedBeginDate),
      endDate: StringUtils.convertDateToString(_selectedEndDate),
      targetDistance: _selectedDistance,
    );
    Provider.of<ChallengeProvider>(context, listen: false)
        .addChallenge(challenge);

    // display list
    Navigator.of(context).pop();
  }

  Widget buildDoneBtn(BuildContext context, Size deviceSize) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        height: 45,
        width: deviceSize.width,
        //color: Colors.white,
        child: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: registerChallenge,
          child: Expanded(
            child: _isLoading
                ? CircularProgressIndicator()
                : Text(
                    "DONE",
                    style: TextStyle(
                      color: Colors.white,
                      // letterSpacing: 1.5,
                      fontSize: 14.0,
                    ),
                  ),
          ),
          color: kPrimaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    List<ChallengeItem> children = <ChallengeItem>[
      ChallengeItem(
          id: 0,
          title: "Begin Date",
          value: _selectedBeginDate,
          display: (DateTime newdate) {
            return DateFormat.yMMMEd().format(newdate);
          },
          callback: (DateTime newdate) {
            setState(() {
              _selectedBeginDate = newdate;
            });
          }),
      ChallengeItem(
          id: 1,
          title: "End Date",
          value: _selectedEndDate,
          display: (DateTime newdate) {
            return DateFormat.yMMMEd().format(newdate);
          },
          callback: (DateTime newdate) {
            setState(() {
              _selectedEndDate = newdate;
            });
          }),
      ChallengeItem(
          id: 2,
          title: "Distances",
          value: _selectedDistance,
          display: (double distance) {
            return "${NumberFormat('0.00').format(distance)}  KM.";
          },
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
          "Challenge Detail",
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.done),
        //     onPressed: registerChallenge,
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Container(
                    child: ChallengeExpansionPanelList(
                      children: children,
                    ),
                  ),
                  Container(
                    width: deviceSize.width * 0.85,
                    child: buildDoneBtn(context, deviceSize),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
