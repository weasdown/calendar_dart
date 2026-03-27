/// Base calendar class. This class doesn't do any formatting. It simply provides data to subclasses.
class Calendar {
  Calendar({this.firstWeekDay = 0});

  /// 0 = Monday, 6 = Sunday
  int firstWeekDay;

  int get getFirstWeekDay => firstWeekDay % 7;

  set setFirstWeekDay(int firstWeekDay) {
    assert(
      firstWeekDay >= 0 && firstWeekDay < 7,
      'firstWeekDay must be an integer between 0 and 6 inclusive.',
    );
    this.firstWeekDay = firstWeekDay;
  }

  /// Return an iterator for one week of weekday numbers starting with the configured first one.
  Iterable<int> iterWeekDays() sync* {
    for (int i = firstWeekDay; i < firstWeekDay + 7; i++) {
      yield i % 7;
    }
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
