import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:running_app/constants.dart';
// import 'package:http/http.dart' as http;
import 'package:running_app/models/user.dart';
import 'package:running_app/util/io_util.dart';

class UserProvider with ChangeNotifier {
  User _user = new User();
  String _jwt;

  User get user {
    return _user;
  }

  set jwt(String jwt) {
    _jwt = jwt;
  }

  Future<void> fetchAndSetUser(int userId) async {
    IOClient ioClient = IOUtil.getIOClient();
    final url = Uri.parse(baseUrl + '/getuser/${userId}');
    var data = await ioClient.get(
      url,
      headers: <String, String>{"Authorization": "Bearer ${_jwt}"},
    );

    if (data.statusCode == HttpStatus.unauthorized) {
      return;
    }

    var jsonData = json.decode(data.body);
    _user = User.fromJson(jsonData);
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    IOClient ioClient = IOUtil.getIOClient();
    _user.parse(user);
    final url = Uri.parse(baseUrl + '/updateuser');
    await ioClient.post(url,
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_jwt}"
        },
        body: jsonEncode(_user.toJson()));
    notifyListeners();
  }
}
