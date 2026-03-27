/// Base calendar class. This class doesn't do any formatting. It simply provides data to subclasses.
class Calendar {
  Calendar({this.firstWeekDay = 0});

  /// 0 = Monday, 6 = Sunday
  int firstWeekDay;

  int getFirstWeekDay() => firstWeekDay % 7;

  void setfirstweekday(int firstWeekDay) {
    this.firstWeekDay = firstWeekDay;
  }

  iterWeekDays() {
    throw UnimplementedError();
  }

  iterMonthDates() {
    throw UnimplementedError();
  }

  iterMonthDays() {
    throw UnimplementedError();
  }

  iterMonthDays2() {
    throw UnimplementedError();
  }

  iterMonthDays3() {
    throw UnimplementedError();
  }

  iterMonthDays4() {
    throw UnimplementedError();
  }

  monthDatesCalendar() {
    throw UnimplementedError();
  }

  monthDays2Calendar() {
    throw UnimplementedError();
  }

  monthDaysCalendar() {
    throw UnimplementedError();
  }

  yearDatesCalendar() {
    throw UnimplementedError();
  }

  yearDays2Calendar() {
    throw UnimplementedError();
  }

  yearDaysCalendar() {
    throw UnimplementedError();
  }
}
