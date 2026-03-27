/// Calendar printing functions
///
/// Note when comparing these calendars to the ones printed by cal(1): By
/// default, these calendars have Monday as the first day of the week, and
/// Sunday as the last (the European convention). Use setfirstweekday() to
/// set the first day of the week (0=Monday, 6=Sunday).
library;

int _boolToInt(bool a) => a ? 1 : 0;

class IllegalMonthError implements Exception {
  IllegalMonthError(this.month);

  final int month;

  @override
  String toString() => 'bad month number $month; must be 1-12';
}

enum Month {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december;

  const Month();

  int get value => index + 1;
}

enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  int operator +(int value) => (index + value) % 7;

  int operator -(int value) => (index - value) % 7;
}

extension IntDay on int {
  int operator -(Day day) => (this - day.index) % 7;

  int operator +(Day day) => (this + day.index) % 7;
}

DateTime date(int year, int month, int day) => DateTime(year, month, day);

/// Number of days per month (except for February in leap years)
const List<int> mDays = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

/// Return [True] for leap years, [False] for non-leap years.
bool isLeap(int year) => year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

/// Return weekday (0-6 ~ Mon-Sun) for [year] (0-9999), [month] (1-12), [day] (1-31).
Day weekday(int year, int month, int day) {
  // Equivalents to Python's datetime.MINYEAR and datetime.MAXYEAR.
  int minYear = 1;
  int maxYear = 9999;

  if (!(year >= minYear && year <= maxYear)) {
    year = 2000 + year % 400;
  }

  return Day.values[DateTime(year, month, day).weekday - 1];
}

void _validateMonth(int month) {
  if (!(month >= 1 && month <= 12)) {
    throw IllegalMonthError(month);
  }
}

/// Return weekday of first day of month (0-6 ~ Mon-Sun) and number of days (28-31) for [year], [month].
(Day day1, int nDays) monthRange(int year, int month) {
  _validateMonth(month);
  Day day1 = weekday(year, month, 1);

  int nDays =
      mDays[month] + _boolToInt(month == Month.february.value && isLeap(year));

  return (day1, nDays);
}

int _monthLen(int year, int month) =>
    mDays[month] + _boolToInt(month == Month.february.value && isLeap(year));

(int y, int m) _prevMonth(int year, int month) =>
    (month == 1) ? (year - 1, 12) : (year, month - 1);

(int y, int m) _nextMonth(int year, int month) =>
    month == 12 ? (year + 1, 1) : (year, month + 1);

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
      yield date(y, m, d);
    }
  }

  // TODO implement method
  /// Like [iterMonthDates()], but will yield day numbers.
  ///
  /// For days outside the specified month the day number is 0.
  Iterable<DateTime> iterMonthDays(int year, int month) sync* {
    throw UnimplementedError();
  }

  // TODO implement method
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
    final (Day day1, int nDays) = monthRange(year, month);
    final int daysBefore = (day1.index - firstWeekDay) % 7;
    final int daysAfter = (firstWeekDay - day1.index - nDays) % 7;
    var (int y, int m) = _prevMonth(year, month);
    final int end = _monthLen(y, m) + 1;

    for (int d = end - daysBefore; d < end; d++) {
      yield (y, m, d);
    }

    for (int d = 1; d < nDays + 1; d++) {
      yield (year, month, d);
    }

    (y, m) = _nextMonth(year, month);
    for (int d = 1; d < daysAfter + 1; d++) {
      yield (y, m, d);
    }
  }

  // TODO implement method
  /// Like [iterMonthDates()], but will yield `(year, month, day, day_of_week)` records.
  ///
  /// Can be used for dates outside of datetime.date range.
  Iterable<(int y, int m, int d, int dow)> iterMonthDays4(
    int year,
    int month,
  ) sync* {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Return a matrix (list of lists) representing a month's calendar.
  ///
  /// Each row represents a week; week entries are datetime.date values.
  List<List<(int, int)>> monthDatesCalendar(int year, int month) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Return a matrix representing a month's calendar.
  ///
  /// Each row represents a week; week entries are `(day number, weekday number)` records. Day numbers outside this month are zero.
  List<List<(int d, int weekday)>> monthDays2Calendar(int year, int month) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Return a matrix representing a month's calendar.
  ///
  /// Each row represents a week; days outside this month are zero.
  List<List<int>> monthDaysCalendar(int year, int month) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Return the data for the specified year ready for formatting.
  ///
  /// The return value is a list of month rows. Each month row contains up to width months. Each month contains between 4 and 6 weeks and each week contains 1-7 days. Days are [DateTime] objects.
  List<List<List<List<DateTime>>>> yearDatesCalendar(
    int year, [
    int width = 3,
  ]) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Return the data for the specified year ready for formatting (similar to [yearDatesCalendar()]).
  ///
  /// Entries in the week lists are `(day number, weekday number)` records. Day numbers outside this month are zero.
  List<List<List<List<(int d, int weekday)>>>> yearDays2Calendar(
    int year, [
    int width = 3,
  ]) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Return the data for the specified year ready for formatting (similar to [yearDatesCalendar()]).
  ///
  /// Entries in the week lists are day numbers. Day numbers outside this month are zero.
  List<List<List<List<int>>>> yearDaysCalendar(int year, [int width = 3]) {
    throw UnimplementedError();
  }
}
