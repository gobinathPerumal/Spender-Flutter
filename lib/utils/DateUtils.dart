import 'package:intl/intl.dart';

class DateUtils{
  static final DateUtils _DateUtils = DateUtils._internal();

  DateUtils._internal();

  factory DateUtils() {
    return _DateUtils;
  }


  String getFormattedTodayDate(){
    return  DateFormat("ddd-MMM-yyyy").format(DateTime.now()).toString();
  }

  List<DateTime>weekDaysList()
  {
    final date = DateTime.parse(DateTime.now().toString());
    return getDaysInBeteween(getDate(date.subtract(Duration(days: date.weekday - 1))), getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday))));
  }
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  List<DateTime> getDaysInBeteween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

}