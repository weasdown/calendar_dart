class IllegalMonthError implements Exception {
  IllegalMonthError(this.month);

  final int month;

  @override
  String toString() => 'bad month number $month; must be 1-12';
}

/// Base calendar class.
///
/// This class doesn't do any formatting. It simply provides data to subclasses.
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

  /// Like [iterMonthDates()], but will yield day numbers.
  ///
  /// For days outside the specified month the day number is 0.
  Iterable<DateTime> iterMonthDays(int year, int month) sync* {
    throw UnimplementedError();
  }

  /// Like [iterMonthDates()], but will yield `(day number, weekday number)` records.
  ///
  /// For days outside the specified month the day number is 0.
  Iterable<DateTime> iterMonthDays2(int year, int month) sync* {
    throw UnimplementedError();
  }

  /// Like [iterMonthDates()], but will yield `(year, month, day)` records.
  ///
  /// Can be used for dates outside of datetime.date range.
  Iterable<(int y, int m, int d)> iterMonthDays3(int year, int month) sync* {
    throw UnimplementedError();
  }

  /// Like [iterMonthDates()], but will yield `(year, month, day, day_of_week)` records.
  ///
  /// Can be used for dates outside of datetime.date range.
  Iterable<(int y, int m, int d, int dow)> iterMonthDays4(
    int year,
    int month,
  ) sync* {
    throw UnimplementedError();
  }

  /// Return a matrix (list of lists) representing a month's calendar.
  ///
  /// Each row represents a week; week entries are datetime.date values.
  List<List<(int, int)>> monthDatesCalendar(int year, int month) {
    throw UnimplementedError();
  }

  /// Return a matrix representing a month's calendar.
  ///
  /// Each row represents a week; week entries are `(day number, weekday number)` records. Day numbers outside this month are zero.
  List<List<(int d, int weekday)>> monthDays2Calendar(int year, int month) {
    throw UnimplementedError();
  }

  /// Return a matrix representing a month's calendar.
  ///
  /// Each row represents a week; days outside this month are zero.
  List<List<int>> monthDaysCalendar(int year, int month) {
    throw UnimplementedError();
  }

  /// Return the data for the specified year ready for formatting.
  ///
  /// The return value is a list of month rows. Each month row contains up to width months. Each month contains between 4 and 6 weeks and each week contains 1-7 days. Days are [DateTime] objects.
  List<List<List<List<DateTime>>>> yearDatesCalendar(
    int year, [
    int width = 3,
  ]) {
    throw UnimplementedError();
  }

  /// Return the data for the specified year ready for formatting (similar to [yearDatesCalendar()]).
  ///
  /// Entries in the week lists are `(day number, weekday number)` records. Day numbers outside this month are zero.
  List<List<List<List<(int d, int weekday)>>>> yearDays2Calendar(
    int year, [
    int width = 3,
  ]) {
    throw UnimplementedError();
  }

  /// Return the data for the specified year ready for formatting (similar to [yearDatesCalendar()]).
  ///
  /// Entries in the week lists are day numbers. Day numbers outside this month are zero.
  List<List<List<List<int>>>> yearDaysCalendar(int year, [int width = 3]) {
    throw UnimplementedError();
  }
}
