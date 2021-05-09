import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/screens/screen.dart';

class HomeScreen extends StatelessWidget {
  Widget buildLoginBtn(BuildContext context, Size deviceSize, String title,
      Widget icon, Color color, Widget screen) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 45,
        width: deviceSize.width * 0.85,
        //color: Colors.white,
        child: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => screen));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: icon,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  " ${title}",
                  style: TextStyle(
                    color: kTextColor,
                    // letterSpacing: 1.5,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  height: deviceSize.height,
                  width: deviceSize.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 100.0),
                        child: Text(
                          'RUNNING APP',
                          style: TextStyle(
                            color:
                                Theme.of(context).accentTextTheme.title.color,
                            fontSize: 26,
                            // fontFamily: 'Anton',
                            // fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    buildLoginBtn(
                      context,
                      deviceSize,
                      'Sigin with Facebook',
                      FaIcon(
                        FontAwesomeIcons.facebookF,
                        size: 17,
                        color: Colors.blue,
                      ),
                      Colors.blue,
                      BottomNavScreen(),
                    ),
                    buildLoginBtn(
                      context,
                      deviceSize,
                      'Sigin with Google',
                      FaIcon(
                        FontAwesomeIcons.google,
                        size: 15,
                        color: Colors.red,
                      ),
                      Colors.red,
                      BottomNavScreen(),
                    ),
                    buildLoginBtn(
                      context,
                      deviceSize,
                      'Signin with Email',
                      Icon(
                        Icons.mail_outlined,
                        size: 20,
                        color: Colors.green,
                      ),
                      kTextColor,
                      SignInScreen(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        width: deviceSize.width * 0.85,
                        //color: Colors.white,
                        child: RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(children: [
                            TextSpan(
                              text: "Don't have an account ? ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: "Signup",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignUpScreen()));
                                },
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
