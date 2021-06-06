import 'package:flutter/cupertino.dart';
import 'package:running_app/constants.dart';

class WeightPicker extends StatefulWidget {
  final double initialWeight;
  final Function onChanged;

  const WeightPicker({Key key, this.initialWeight, this.onChanged})
      : super(key: key);
  @override
  _WeightPickerState createState() =>
      _WeightPickerState(initialWeight, onChanged);
}

class _WeightPickerState extends State<WeightPicker> {
  final double initialWeight;
  final Function onChanged;
  int intDigit = 0;
  int decDigit = 0;

  void setDistance() {
    double weight =
        double.parse(intDigit.toString() + "." + decDigit.toString());
    print(weight);
    onChanged(weight);
  }

  _WeightPickerState(this.initialWeight, this.onChanged);

  @override
  void initState() {
    super.initState();
    setState(() {
      intDigit = initialWeight.toInt();
      if (initialWeight.toString().contains(".")) {
        var splitValue = initialWeight.toString().split(".");
        intDigit = int.parse(splitValue[0]);
        decDigit = int.parse(splitValue[1]);
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
              width: 120,
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
                    flex: 3,
                    child: CupertinoPicker(
                      selectionOverlay: Container(),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int value) {
                        setState(() {
                          decDigit = value;
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
                          FixedExtentScrollController(initialItem: decDigit),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "KG.",
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
