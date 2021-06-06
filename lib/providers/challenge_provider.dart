import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/models/challenge.dart';
// import 'package:http/http.dart' as http;
import 'package:running_app/util/io_util.dart';

class ChallengeProvider with ChangeNotifier {
  List<Challenge> _challenges = [];
  String _jwt;
  IOClient ioClient = IOUtil.getIOClient();

  List<Challenge> get challenges {
    return _challenges;
  }

  set jwt(String jwt) {
    _jwt = jwt;
  }

  Future<void> fetchAndSetChallenges() async {
    final url = Uri.parse(baseUrl + '/getallchallenges');
    var data = await ioClient
        .get(url, headers: <String, String>{"Authorization": "Bearer ${_jwt}"});

    if (data.statusCode == HttpStatus.unauthorized) {
      return;
    }

    _challenges = [];
    var jsonData = json.decode(data.body);
    for (var elm in jsonData) {
      Challenge challenge = Challenge.fromJson(elm);
      _challenges.add(challenge);
    }
    notifyListeners();
  }

  Future<void> addChallenge(Challenge challenge) async {
    final url = Uri.parse(baseUrl + '/addchallenge');
    await ioClient.post(url,
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_jwt}"
        },
        body: jsonEncode(challenge.toJson()));
  }
}
