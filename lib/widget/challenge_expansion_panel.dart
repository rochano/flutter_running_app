import 'package:flutter/material.dart';
import 'package:running_app/constants.dart';

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
    Size size = MediaQuery.of(context).size;
    List<Widget> bodyWidgets = [
      DatePicker(
        initialDateTime: children[0].value,
        minimumYear: DateTime.now().year - 5,
        maximumYear: DateTime.now().year + 5,
        onDateTimeChanged: (DateTime newdate) {
          setState(() {
            children[0].value = newdate;
            children[0].callback(newdate);
          });
        },
      ),
      DatePicker(
        initialDateTime: children[1].value,
        minimumYear: DateTime.now().year - 5,
        maximumYear: DateTime.now().year + 5,
        onDateTimeChanged: (DateTime newdate) {
          setState(() {
            children[1].value = newdate;
            children[1].callback(newdate);
          });
        },
      ),
      DistancePicker(
        initialDistance: children[2].value,
        onChanged: (double distance) {
          setState(() {
            children[2].value = distance;
            children[2].callback(distance);
          });
        },
      ),
    ];

    List<MergeableMaterialItem> items = <MergeableMaterialItem>[];
    for (int index = 0; index < children.length; index += 1) {
      items.add(MaterialSlice(
          key: ValueKey(index * 2),
          child: Container(
            width: size.width * 0.5,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.8, color: kTextColor),
              ),
            ),
            padding: EdgeInsets.only(bottom: 8),
            margin: EdgeInsets.only(left: 10, right: 10, top: 15),
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
            ),
          )));
    }

    return MergeableMaterial(
      children: items,
      elevation: 0,
    );
  }
}

class ChallengeItem {
  final int id;
  final String title;
  Object value;
  Function display;
  bool isExpanded;
  Function callback;

  ChallengeItem(
      {this.id, this.title, this.value, this.display, this.isExpanded, this.callback});
}

class ChallengeDetailContent extends StatelessWidget {
  final ChallengeItem item;
  final Function() onTap;

  const ChallengeDetailContent({Key key, this.item, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
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
                    text: item.display(item.value),
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
    );
  }
}
