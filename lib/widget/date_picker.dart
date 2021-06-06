import 'package:flutter/cupertino.dart';
import 'package:running_app/constants.dart';

class DatePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final int minimumYear;
  final int maximumYear;
  final Function onDateTimeChanged;

  const DatePicker(
      {Key key,
      this.initialDateTime,
      this.onDateTimeChanged,
      this.minimumYear,
      this.maximumYear})
      : super(key: key);
  @override
  _DatePickerState createState() => _DatePickerState(
      initialDateTime, minimumYear, maximumYear, onDateTimeChanged);
}

class _DatePickerState extends State<DatePicker> {
  final DateTime initialDateTime;
  final int minimumYear;
  final int maximumYear;
  final Function onDateTimeChanged;

  _DatePickerState(this.initialDateTime, this.minimumYear, this.maximumYear,
      this.onDateTimeChanged);
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
          initialDateTime: initialDateTime,
          onDateTimeChanged: (DateTime newdate) {
            print(newdate);
            onDateTimeChanged(newdate);
          },
          use24hFormat: true,
          // maximumDate: new DateTime(2022, 12, 30),
          minimumYear: minimumYear,
          maximumYear: maximumYear,
          minuteInterval: 1,
          mode: CupertinoDatePickerMode.date,
        ),
      ),
    );
  }
}
