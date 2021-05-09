import 'package:flutter/cupertino.dart';

import '../constants.dart';

class DatePicker extends StatefulWidget {
  final Function onDateTimeChanged;

  const DatePicker({Key key, this.onDateTimeChanged}) : super(key: key);
  @override
  _DatePickerState createState() => _DatePickerState(onDateTimeChanged);
}

class _DatePickerState extends State<DatePicker> {
  final Function onDateTimeChanged;

  _DatePickerState(this.onDateTimeChanged);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: kDefaultPickerTextStyle,
          ),
        ),
        child: CupertinoDatePicker(
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime newdate) {
            print(newdate);
            onDateTimeChanged(newdate);
          },
          use24hFormat: true,
          maximumDate: new DateTime(2022, 12, 30),
          minimumYear: 2010,
          maximumYear: 2022,
          minuteInterval: 1,
          mode: CupertinoDatePickerMode.date,
        ),
      ),
    );
  }
}
