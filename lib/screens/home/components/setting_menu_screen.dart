import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/providers/auth_provider.dart';
import 'package:running_app/screens/screen.dart';

class SettingMenuScreen extends StatelessWidget {
  Future<void> logoutUser(BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
    // Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(pageBuilder: (BuildContext context,
            Animation animation, Animation secondaryAnimation) {
          return HomeScreen();
        }),
        (Route route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Setting",
        ),
        leading: Container(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavScreen(
                  initialIndex: 3,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            height: 50,
            child: MaterialButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(),
                ),
              ),
              child: RichText(
                text: TextSpan(
                  text: "EDIT PROFILE",
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: 16,
                  ),
                ),
              ),
              minWidth: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 50,
            child: MaterialButton(
              onPressed: () => logoutUser(context),
              child: RichText(
                text: TextSpan(
                  text: "LOGOUT",
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 16,
                  ),
                ),
              ),
              minWidth: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ],
      ),
    );
  }
}
