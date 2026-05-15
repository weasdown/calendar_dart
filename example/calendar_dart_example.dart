import 'package:calendar_dart/calendar.dart';

void main() {
  final DateTime today = DateTime.now();
  final int year = today.year;
  final int month = today.month;

  final TextCalendar tCal = TextCalendar();

  tCal.prMonth(year, month);
}
