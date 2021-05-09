import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import 'date_picker.dart';
import 'distance_picker.dart';

class ChallengeExpansionPanelList extends StatefulWidget {
  final List<ChallengeItem> children;

  ChallengeExpansionPanelList({Key key, this.children}) : super(key: key);
  @override
  _ChallengeExpansionPanelListState createState() =>
      _ChallengeExpansionPanelListState(children);
}

class _ChallengeExpansionPanelListState
    extends State<ChallengeExpansionPanelList> {
  final List<ChallengeItem> children;
  ChallengeItem currentItem;

  _ChallengeExpansionPanelListState(this.children);

  bool _isChildExpanded(int index, bool isExpanded) {
    return currentItem?.id == children[index].id && isExpanded;
  }

  void setExpanded(int index) {
    if (currentItem?.id != children[index].id) {
      children[index].isExpanded = true;
      currentItem = children[index];
    } else {
      children[index].isExpanded = !children[index].isExpanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyWidgets = [
      DatePicker(
        onDateTimeChanged: (DateTime newdate) {
          setState(() {
            children[0].value = DateFormat.yMMMEd().format(newdate);
            children[0].callback(newdate);
          });
        },
      ),
      DatePicker(
        onDateTimeChanged: (DateTime newdate) {
          setState(() {
            children[1].value = DateFormat.yMMMEd().format(newdate);
            children[1].callback(newdate);
          });
        },
      ),
      DistancePicker(
        onChanged: (double distance) {
          setState(() {
            children[2].value = "${NumberFormat('0.00').format(distance)}  KM.";
            children[2].callback(distance);
          });
        },
      ),
    ];

    List<MergeableMaterialItem> items = <MergeableMaterialItem>[];
    for (int index = 0; index < children.length; index += 1) {
      items.add(MaterialSlice(
          key: ValueKey(index * 2),
          child: Column(
            children: <Widget>[
              ChallengeDetailContent(
                item: children[index],
                onTap: () {
                  setState(() {
                    setExpanded(index);
                  });
                },
              ),
              AnimatedCrossFade(
                firstChild: Container(
                  height: 0,
                ),
                secondChild: bodyWidgets[index],
                firstCurve:
                    const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve:
                    const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState:
                    _isChildExpanded(index, children[index].isExpanded)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 200),
              )
            ],
          )));
    }

    return MergeableMaterial(
      children: items,
    );
  }
}

class ChallengeItem {
  final int id;
  final String title;
  String value;
  bool isExpanded;
  Function callback;

  ChallengeItem(
      {this.id, this.title, this.value, this.isExpanded, this.callback});
}

class ChallengeDetailContent extends StatelessWidget {
  final ChallengeItem item;
  final Function() onTap;

  const ChallengeDetailContent({Key key, this.item, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding,
            vertical: kDefaultVerticalPadding),
        child: Row(
          children: <Widget>[
            Container(
              width: size.width * 0.5,
              child: RichText(
                text: TextSpan(
                  text: item.title,
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: onTap,
                  child: RichText(
                    text: TextSpan(
                      text: item.value,
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
