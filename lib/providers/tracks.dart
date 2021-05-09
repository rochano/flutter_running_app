import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/models/track.dart';
import 'package:http/http.dart' as http;

class Tracks with ChangeNotifier {
  List<Track> _tracks = [];
  String _jwt;

  List<Track> get tracks {
    return _tracks;
  }

  set jwt(String jwt) {
    _jwt = jwt;
  }

  Future<void> fetchAndSetTracks() async {
    var data = await http.get(baseUrl + "/getalltracks",
        headers: <String, String>{"Authorization": "Bearer ${_jwt}"});
    var jsonData = json.decode(data.body);

    List<Track> loadedTracks = [];
    for (var elm in jsonData) {
      Track track = Track.fromJson(elm);
      loadedTracks.add(track);
    }
    _tracks = loadedTracks;
    notifyListeners();
  }
}
