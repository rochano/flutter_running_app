import 'package:flutter/material.dart';
import 'package:running_app/components/track_list.dart';
import 'package:running_app/constants.dart';

class HomeStlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: TrackList(),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 80,
        color: kPrimaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BottomNavItem(title: "RUN",),
            BottomNavItem(title: "TRACK", isSelected: true,),
            BottomNavItem(title: "CHALLENGE",),
            BottomNavItem(title: "USER",)
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Text("Running App"),
      );
  }
}

class BottomNavItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  const BottomNavItem({
    Key key, 
    this.title, 
    this.isSelected = false, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(15),
            decoration: isSelected ? 
              BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(10)
              ): 
              BoxDecoration(),
            child: Text(title, style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.white70
            ),),
          )
        ],
      ),
    );
  }
}