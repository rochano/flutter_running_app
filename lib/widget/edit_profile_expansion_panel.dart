import 'package:flutter/material.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/widget/height_picker.dart';
import 'package:running_app/widget/weight_picker.dart';

import 'date_picker.dart';

class EditProfileExpansionPanelList extends StatefulWidget {
  final List<EditProfileItem> children;

  EditProfileExpansionPanelList({Key key, this.children}) : super(key: key);
  @override
  _EditProfileExpansionPanelListState createState() =>
      _EditProfileExpansionPanelListState(children);
}

class _EditProfileExpansionPanelListState
    extends State<EditProfileExpansionPanelList> {
  final List<EditProfileItem> children;
  EditProfileItem currentItem;

  _EditProfileExpansionPanelListState(this.children);

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
        minimumYear: DateTime.now().year - 100,
        maximumYear: DateTime.now().year,
        onDateTimeChanged: (DateTime newdate) {
          setState(() {
            children[0].value = newdate;
            children[0].callback(newdate);
          });
        },
      ),
      WeightPicker(
        initialWeight: children[1].value,
        onChanged: (double weight) {
          setState(() {
            children[1].value = weight;
            children[1].callback(weight);
          });
        },
      ),
      HeightPicker(
        initialHeight: children[2].value,
        onChanged: (double height) {
          setState(() {
            children[2].value = height;
            children[2].callback(height);
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
            padding: EdgeInsets.only(top: 15, bottom: 8),
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: <Widget>[
                EditProfileDetailContent(
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

class EditProfileItem {
  final int id;
  final String title;
  Object value;
  Function display;
  bool isExpanded;
  Function callback;

  EditProfileItem(
      {this.id,
      this.title,
      this.value,
      this.display,
      this.isExpanded,
      this.callback});
}

class EditProfileDetailContent extends StatelessWidget {
  final EditProfileItem item;
  final Function() onTap;

  const EditProfileDetailContent({Key key, this.item, this.onTap})
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
