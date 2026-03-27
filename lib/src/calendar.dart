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

  /// Return an iterator for one month.
  ///
  /// The iterator will yield datetime.date values and will always iterate through complete weeks, so it will yield dates outside the specified month.
  Iterable<DateTime> iterMonthDates(int year, int month) sync* {
    for (final (int y, int m, int d) in iterMonthDays3(year, month)) {
      yield DateTime(y, m, d);
    }
  }

  Iterable<DateTime> iterMonthDays(int year, int month) sync* {
    throw UnimplementedError();
  }

  Iterable<DateTime> iterMonthDays2(int year, int month) sync* {
    throw UnimplementedError();
  }

  Iterable<(int y, int m, int d)> iterMonthDays3(int year, int month) sync* {
    throw UnimplementedError();
  }

  Iterable<(int y, int m, int d, int dow)> iterMonthDays4(
    int year,
    int month,
  ) sync* {
    throw UnimplementedError();
  }

  List<List<(int, int)>> monthDatesCalendar(int year, int month) {
    throw UnimplementedError();
  }

  List<List<(int d, int weekday)>> monthDays2Calendar(int year, int month) {
    throw UnimplementedError();
  }

  List<List<int>> monthDaysCalendar(int year, int month) {
    throw UnimplementedError();
  }

  List<List<List<List<DateTime>>>> yearDatesCalendar(
    int year, [
    int width = 3,
  ]) {
    throw UnimplementedError();
  }

  List<List<List<List<(int d, int weekday)>>>> yearDays2Calendar(
    int year, [
    int width = 3,
  ]) {
    throw UnimplementedError();
  }

  List<List<List<List<int>>>> yearDaysCalendar(int year, [int width = 3]) {
    throw UnimplementedError();
  }
}
