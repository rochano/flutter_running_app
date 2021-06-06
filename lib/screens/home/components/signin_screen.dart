import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/providers/provider.dart';
import 'package:running_app/screens/screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  Widget buildForgetPassword() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          // height: 35,
          //color: Colors.white,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Forgot password ?",
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      color: kTextColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgetPasswordScreen(),
                              ),
                            )
                          }),
              ],
            ),
          ),
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

  Future<void> loginUser() async {
    await Provider.of<AuthProvider>(context, listen: false)
        .authenticate(_authData['email'], _authData['password']);
    if (Provider.of<AuthProvider>(context, listen: false).isAuth) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavScreen(
            initialIndex: 1,
          ),
        ),
      );
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
      await loginUser();
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
      // print(error);
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget buildLoginBtn(BuildContext context, Size deviceSize) {
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
                    "LOGIN",
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Sign In",
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            width: deviceSize.width * 0.85,
            child: ListView(
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
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                ),
                buildForgetPassword(),
                buildLoginBtn(context, deviceSize),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
