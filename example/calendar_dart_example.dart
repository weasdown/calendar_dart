import 'package:calendar_dart/calendar_dart.dart';

void main() {
  Calendar cal = Calendar();
  print('cal.firstWeekDay: ${cal.firstWeekDay}');

  int newFirstWeekDay = 8;
  print('Setting cal\'s firstWeekDay to $newFirstWeekDay');
  cal.setFirstWeekDay = newFirstWeekDay;
}
