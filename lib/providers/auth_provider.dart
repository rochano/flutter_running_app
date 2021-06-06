import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/models/user.dart';
// import 'package:http/http.dart' as http;
import 'package:running_app/util/io_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  int _userId;
  String _jwt;
  DateTime _expiration;
  IOClient ioClient = IOUtil.getIOClient();

  bool get isAuth {
    return jwt != null;
  }

  int get userId {
    return _userId;
  }

  String get jwt {
    if (_expiration != null &&
        _expiration.isAfter(DateTime.now()) &&
        _jwt != null) {
      return _jwt;
    }
    return null;
  }

  Future<void> authenticate(String email, String password) async {
    User user = new User(
      email: email,
      password: password,
    );

    final url = Uri.parse(baseUrl + '/authenticate');
    final response = await ioClient.post(url,
        // final response = await ioClient.post(url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()));
    // final response = await http.post(url,
    //     headers: <String, String>{"Content-Type": "application/json"},
    //     body: jsonEncode(user.toJson()));
    final responseData = json.decode(response.body);
    if (response.statusCode == HttpStatus.internalServerError) {
      throw HttpException(responseData['message']);
    }

    _jwt = responseData['jwt'];
    _userId = int.parse(responseData['userId']);
    _expiration = DateTime.parse(responseData['expiration']);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', response.body);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final userId = int.parse(extractedUserData['userId']);
    final expiration = DateTime.parse(extractedUserData['expiration']);

    if (expiration.isBefore(DateTime.now())) {
      return false;
    }
    _jwt = extractedUserData['jwt'];
    _userId = userId;
    _expiration = expiration;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _jwt = null;
    _userId = null;
    _expiration = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
