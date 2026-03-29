import 'package:calendar_dart/calendar.dart';

void main() {
  Calendar cal = Calendar();
  print('cal.firstWeekDay: ${cal.firstWeekDay}');

  int newFirstWeekDay = 6;
  print('Setting cal\'s firstWeekDay to $newFirstWeekDay');
  cal.setFirstWeekDay = newFirstWeekDay;

  print('\niterWeekDays: ${cal.iterWeekDays()}');
  cal.firstWeekDay = 6;
  print(cal.iterWeekDays());
}
