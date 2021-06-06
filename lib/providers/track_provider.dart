import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/models/track.dart';
// import 'package:http/http.dart' as http;
import 'package:running_app/util/io_util.dart';

class TrackProvider with ChangeNotifier {
  List<Track> _tracks = [];
  String _jwt;
  IOClient ioClient = IOUtil.getIOClient();

  List<Track> get tracks {
    return _tracks;
  }

  set jwt(String jwt) {
    _jwt = jwt;
  }

  Future<void> fetchAndSetTracks() async {
    final url = Uri.parse(baseUrl + '/getalltracks');
    var data = await ioClient
        .get(url, headers: <String, String>{"Authorization": "Bearer ${_jwt}"});

    if (data.statusCode == HttpStatus.unauthorized) {
      return;
    }

    _tracks = [];
    var jsonData = json.decode(data.body);
    for (var elm in jsonData) {
      Track track = Track.fromJson(elm);
      _tracks.add(track);
    }
    notifyListeners();
  }

  Future<void> addTrack(Track track) async {
    final url = Uri.parse(baseUrl + '/addtrack');
    var body = jsonEncode(track.toJson());
    await ioClient.post(url,
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_jwt}"
        },
        body: body);
  }
}
