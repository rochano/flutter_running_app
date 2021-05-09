import 'package:flutter/material.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/screens/screen.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final List _screen = [RunningMap(), TrackList(), ChallengeList(), Scaffold()];
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Navigator(
          key: GlobalKey<NavigatorState>(),
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(
                builder: (context) => _screen[_currentIndex]);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: kPrimaryColor,
            elevation: 0.0,
            items: ["RUN", "TRACK", "CHALLENGE", "USER"]
                .asMap()
                .map((key, value) => MapEntry(
                    key,
                    BottomNavigationBarItem(
                        title: Text(""),
                        icon: Container(
                          width: (MediaQuery.of(context).size.width / 4) * 0.9,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          decoration: BoxDecoration(
                              color: _currentIndex == key
                                  ? Colors.orange
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            value,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _currentIndex == key
                                    ? Colors.white
                                    : Colors.white70),
                          ),
                        ))))
                .values
                .toList()));
  }
}
