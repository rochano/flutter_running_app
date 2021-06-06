import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/providers/provider.dart';
import 'package:running_app/screens/screen.dart';

class UserDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).userId;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "User",
        ),
        leading: Container(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingMenuScreen(),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false)
            .fetchAndSetUser(userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Consumer<UserProvider>(
            builder: (context, userData, child) => Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  // color: Colors.black,
                                  // borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: Colors.blueAccent)),
                              child: userData.user.image != null
                                  ? userData.user.isImageAsUrl()
                                      ? CachedNetworkImage(
                                          imageUrl: userData.user.image,
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                          placeholder: (context, url) =>
                                              Center(child: new CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                        )
                                      : Image.file(
                                          File(userData.user.image),
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                        )
                                  : Container(),
                            ),
                            Container(
                              height: 60,
                              alignment: Alignment.topLeft,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text:
                                        "${userData.user.firstName} ${userData.user.lastName}\n",
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Joined Jan 01, 2020",
                                    style: TextStyle(
                                        color: kTextColor,
                                        fontSize: 12,
                                        height: 2.0),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  text: TextSpan(
                                    text: "0 Following",
                                    style: TextStyle(
                                        color: kTextColor, fontSize: 14),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  alignment: Alignment.topLeft,
                                  child: RichText(
                                    text: TextSpan(
                                      text: "0 Followers",
                                      style: TextStyle(
                                          color: kTextColor, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
