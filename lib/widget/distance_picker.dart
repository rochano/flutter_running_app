import 'package:flutter/cupertino.dart';

import '../constants.dart';

class DistancePicker extends StatefulWidget {
  final Function onChanged;

  const DistancePicker({Key key, this.onChanged}) : super(key: key);
  @override
  _DistancePickerState createState() => _DistancePickerState(onChanged);
}

class _DistancePickerState extends State<DistancePicker> {
  final Function onChanged;
  int intDigit = 0;
  int dec1Digit = 0;
  int dec2Digit = 0;

  void setDistance() {
    double distance = double.parse(intDigit.toString() +
        "." +
        dec1Digit.toString() +
        dec2Digit.toString());
    print(distance);
    onChanged(distance);
  }

  _DistancePickerState(this.onChanged);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Stack(
        children: <Widget>[
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(
                height: 32.0,
              ),
              child: Container(
                margin: EdgeInsets.only(
                  left: 9,
                  right: 8,
                ),
                height: 32.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(8),
                    right: Radius.circular(8),
                  ),
                  color: CupertinoColors.tertiarySystemFill,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CupertinoPicker(
                      selectionOverlay: Container(),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int value) {
                        setState(() {
                          intDigit = value;
                          setDistance();
                        });
                      },
                      children: List<Widget>.generate(300, (int index) {
                        return Align(
                          alignment: Alignment.center,
                          child: Text(
                            (index).toString(),
                            style: kDefaultPickerTextStyle,
                          ),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ".",
                        style: kDefaultPickerTextStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: CupertinoPicker(
                      selectionOverlay: Container(),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int value) {
                        setState(() {
                          dec1Digit = value;
                          setDistance();
                        });
                      },
                      children: List<Widget>.generate(10, (int index) {
                        return Align(
                          alignment: Alignment.center,
                          child: Text((index).toString(),
                              style: kDefaultPickerTextStyle),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: CupertinoPicker(
                      selectionOverlay: Container(),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int value) {
                        setState(() {
                          dec2Digit = value;
                          setDistance();
                        });
                      },
                      children: List<Widget>.generate(10, (int index) {
                        return Align(
                          alignment: Alignment.center,
                          child: Text(
                            (index).toString(),
                            style: kDefaultPickerTextStyle,
                          ),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "KM.",
                        style: kDefaultPickerTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
