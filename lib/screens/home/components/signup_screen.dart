import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:running_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:running_app/models/user.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'firstName': '',
    'lastName': '',
  };
  var _isLoading = false;

  Widget buildRegisterBtn(BuildContext context, Size deviceSize) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        height: 45,
        width: deviceSize.width,
        //color: Colors.white,
        child: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: _submit,
          child: Expanded(
            child: _isLoading
                ? CircularProgressIndicator()
                : Text(
                    "REGISTER",
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void registerUser() async {
    User user = new User(
      email: _authData['email'],
      password: _authData['password'],
      firstName: _authData['firstName'],
      lastName: _authData['lastName'],
    );

    final url = Uri.parse(baseUrl + '/adduser');
    final response = await http.post(url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()));
    final responseData = json.decode(response.body);
    if (response.statusCode == HttpStatus.internalServerError) {
      throw HttpException(responseData['message']);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      // // Sign user up
      await registerUser();
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Sign Up",
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: deviceSize.width * 0.85,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 45,
                    child: TextFormField(
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        // border: InputBorder.none,
                        prefixIcon: Icon(Icons.mail_outlined),
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                      },
                      onSaved: (value) {
                        _authData['email'] = value;
                      },
                    ),
                  ),
                  Container(
                    height: 45,
                    child: TextFormField(
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        // border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock_outline),
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                      obscureText: true,
                      validator: (value) {
                        // if (value.isEmpty || value.length < 5) {
                        //   return 'Password is too short!';
                        // }
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    ),
                  ),
                  Container(
                    height: 45,
                    child: TextFormField(
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        // border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock_outline),
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                      obscureText: true,
                      validator: (value) {
                        // if (value.isEmpty || value.length < 5) {
                        //   return 'Password is too short!';
                        // }
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    ),
                  ),
                  Container(
                    height: 45,
                    child: TextFormField(
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        // border: InputBorder.none,
                        prefixIcon: Icon(Icons.person_outline),
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        _authData['firstName'] = value;
                      },
                    ),
                  ),
                  Container(
                    height: 45,
                    child: TextFormField(
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        // border: InputBorder.none,
                        prefixIcon: Icon(Icons.family_restroom_outlined),
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        _authData['lastName'] = value;
                      },
                    ),
                  ),
                  buildRegisterBtn(context, deviceSize),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
