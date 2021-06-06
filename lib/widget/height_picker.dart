import 'package:flutter/cupertino.dart';
import 'package:running_app/constants.dart';

class HeightPicker extends StatefulWidget {
  final double initialHeight;
  final Function onChanged;

  const HeightPicker({Key key, this.initialHeight, this.onChanged})
      : super(key: key);
  @override
  _HeightPickerState createState() =>
      _HeightPickerState(initialHeight, onChanged);
}

class _HeightPickerState extends State<HeightPicker> {
  final double initialHeight;
  final Function onChanged;
  int intDigit = 0;

  void setDistance() {
    double height = double.parse(intDigit.toString());
    print(height);
    onChanged(height);
  }

  _HeightPickerState(this.initialHeight, this.onChanged);

  @override
  void initState() {
    super.initState();
    setState(() {
      intDigit = initialHeight.toInt();
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
              width: 100,
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
                      scrollController:
                          FixedExtentScrollController(initialItem: intDigit),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "CM.",
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
