import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _jwt;
  DateTime _expiration;

  bool get isAuth {
    return jwt != null;
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

    final response = await http.post(baseUrl + '/authenticate',
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()));
    final responseData = json.decode(response.body);
    if (response.statusCode == HttpStatus.internalServerError) {
      throw HttpException(responseData['message']);
    }

    _jwt = responseData['jwt'];
    _expiration = DateTime.parse(responseData['expiration']);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', response.body);
  }
}
