import 'package:flutter/material.dart';
import 'package:running_app/constants.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  Map<String, String> _authData = {
    'email': '',
  };

    Widget buildRecoverBtn(BuildContext context, Size deviceSize) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        height: 45,
        width: deviceSize.width,
        //color: Colors.white,
        child: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: () {},
          child: Expanded(
            child: Text(
              "RESET PASSWORD",
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
          "Password Recovery",
        ),
      ),
      body: Center(
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
              buildRecoverBtn(context, deviceSize),
            ],
          ),
        ),
      ),
    );
  }
}
