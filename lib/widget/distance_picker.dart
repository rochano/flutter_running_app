import 'package:flutter/cupertino.dart';
import 'package:running_app/constants.dart';

class DistancePicker extends StatefulWidget {
  final double initialDistance;
  final Function onChanged;

  const DistancePicker({Key key, this.initialDistance, this.onChanged})
      : super(key: key);
  @override
  _DistancePickerState createState() =>
      _DistancePickerState(initialDistance, onChanged);
}

class _DistancePickerState extends State<DistancePicker> {
  final double initialDistance;
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

  _DistancePickerState(this.initialDistance, this.onChanged);

  @override
  void initState() {
    super.initState();
    setState(() {
      intDigit = initialDistance.toInt();
      if (initialDistance.toString().contains(".")) {
        var splitValue = initialDistance.toString().split(".");
        intDigit = int.parse(splitValue[0]);
        dec1Digit = int.parse(splitValue[1][0]);
        if (splitValue[1].length > 1) {
          dec2Digit = int.parse(splitValue[1][1]);
        }
      }
    });
  }

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
              width: 180,
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
                      children: List<Widget>.generate(
                        300,
                        (int index) {
                          return Align(
                            alignment: Alignment.center,
                            child: Text(
                              (index).toString(),
                              style: kDefaultPickerTextStyle,
                            ),
                          );
                        },
                      ),
                      scrollController:
                          FixedExtentScrollController(initialItem: intDigit),
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
                    flex: 2,
                    child: CupertinoPicker(
                      selectionOverlay: Container(),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int value) {
                        setState(() {
                          dec1Digit = value;
                          setDistance();
                        });
                      },
                      children: List<Widget>.generate(
                        10,
                        (int index) {
                          return Align(
                            alignment: Alignment.center,
                            child: Text((index).toString(),
                                style: kDefaultPickerTextStyle),
                          );
                        },
                      ),
                      scrollController:
                          FixedExtentScrollController(initialItem: dec1Digit),
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
                      children: List<Widget>.generate(
                        10,
                        (int index) {
                          return Align(
                            alignment: Alignment.center,
                            child: Text(
                              (index).toString(),
                              style: kDefaultPickerTextStyle,
                            ),
                          );
                        },
                      ),
                      scrollController:
                          FixedExtentScrollController(initialItem: dec2Digit),
                    ),
                  ),
                  Expanded(
                    flex: 2,
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
