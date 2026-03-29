/// Calendar printing functions
///
/// Note when comparing these calendars to the ones printed by cal(1): By
/// default, these calendars have Monday as the first day of the week, and
/// Sunday as the last (the European convention). Use setfirstweekday() to
/// set the first day of the week (0=Monday, 6=Sunday).
library;

int _boolToInt(bool a) => a ? 1 : 0;

extension CenterString on String {
  // TODO implement String extension method
  /// Equivalent of Python's built-in `center()` function.
  ///
  /// Return centered in a string of length [width]. Padding is done using the specified [fillChar] (default is an ASCII space). The original string is returned if width is less than or equal to `this.length`.
  String center(int width, [String fillChar = ' ']) {
    throw UnimplementedError();
  }
}

/// Equivalent of Python's [`range()`](https://docs.python.org/3/library/stdtypes.html#range).
Iterable<int> _range(int start, int stop, [int step = 1]) sync* {
  for (int i = start; i < stop; i += step) {
    yield i;
  }
}

/// Repeats [value] [n] times.
///
/// Approximately equivalent to Python's [`itertools.repeat()`], but with a mandatory [times] argument.
///
/// [`itertools.repeat()`]: https://docs.python.org/3/library/itertools.html#itertools.repeat
Iterable<T> repeat<T extends Object>(T value, int times) sync* {
  for (int i = 0; i < times; i++) {
    yield value;
  }
}

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
base class Calendar {
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

  /// Like [iterMonthDates()], but will yield day numbers.
  ///
  /// For days outside the specified month the day number is 0.
  Iterable<int> iterMonthDays(int year, int month) sync* {
    final (Day day1, int nDays) = monthRange(year, month);
    final int daysBefore = (day1 - firstWeekDay) % 7;

    // Equivalent to Python's `yield from repeat(0, days_before)`.
    yield* repeat(0, daysBefore);

    // Equivalent to Python's `yield from range(1, ndays + 1)`.
    yield* List<int>.generate(nDays, (int i) => i + 1, growable: false);

    final int daysAfter = (IntDay(firstWeekDay) - day1 - nDays) % 7;

    // Equivalent to Python's `yield from repeat(0, days_after)`.
    yield* repeat(0, daysAfter);
  }

  /// Like [iterMonthDates()], but will yield `(day number, weekday number)` records.
  ///
  /// For days outside the specified month the day number is 0.
  Iterable<(int d, int weekday)> iterMonthDays2(int year, int month) sync* {
    for (final (int index, int d) in iterMonthDays(year, month).indexed) {
      yield (d, (index + firstWeekDay) % 7);
    }
  }

  /// Like [iterMonthDates()], but will yield `(year, month, day)` records.
  ///
  /// Can be used for dates outside of datetime.date range.
  Iterable<(int y, int m, int d)> iterMonthDays3(int year, int month) sync* {
    final (Day day1, int nDays) = monthRange(year, month);
    final int daysBefore = (day1 - firstWeekDay) % 7;
    final int daysAfter = (IntDay(firstWeekDay) - day1 - nDays) % 7;
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

  /// Like [iterMonthDates()], but will yield `(year, month, day, day_of_week)` records.
  ///
  /// Can be used for dates outside of datetime.date range.
  Iterable<(int y, int m, int d, int dow)> iterMonthDays4(
    int year,
    int month,
  ) sync* {
    for (final (int index, (int y, int m, int d)) in iterMonthDays3(
      year,
      month,
    ).indexed) {
      yield (y, m, d, (firstWeekDay + index) % 7);
    }
  }

  /// Return a matrix (list of lists) representing a month's calendar.
  ///
  /// Each row represents a week; week entries are datetime.date values.
  List<List<DateTime>> monthDatesCalendar(int year, int month) {
    final List<DateTime> dates = iterMonthDates(year, month).toList();

    // Equivalent to Python's `range(0, len(dates), 7)`.
    final List<int> range = List<int>.generate(
      (dates.length / 7).toInt(),
      (i) => 7 * i,
      growable: false,
    );

    return range.map((int i) => dates.sublist(i, i + 7)).toList();
  }

  /// Return a matrix representing a month's calendar.
  ///
  /// Each row represents a week; week entries are `(day number, weekday number)` records. Day numbers outside this month are zero.
  List<List<(int d, int weekday)>> monthDays2Calendar(int year, int month) {
    final List<(int, int)> days = iterMonthDays2(year, month).toList();

    // Equivalent to Python's `range(0, len(days), 7)`.
    final List<int> range = List<int>.generate(
      (days.length / 7).toInt(),
      (i) => 7 * i,
      growable: false,
    );

    return range.map((int i) => days.sublist(i, i + 7)).toList();
  }

  /// Return a matrix representing a month's calendar.
  ///
  /// Each row represents a week; days outside this month are zero.
  List<List<int>> monthDaysCalendar(int year, int month) {
    final List<int> days = iterMonthDays(year, month).toList();

    // Equivalent to Python's `range(0, len(days), 7)`.
    final List<int> range = List<int>.generate(
      (days.length / 7).toInt(),
      (i) => 7 * i,
      growable: false,
    );

    return range.map((int i) => days.sublist(i, i + 7)).toList();
  }

  /// Return the data for the specified year ready for formatting.
  ///
  /// The return value is a list of month rows. Each month row contains up to width months. Each month contains between 4 and 6 weeks and each week contains 1-7 days. Days are [DateTime] objects.
  List<List<List<List<DateTime>>>> yearDatesCalendar(
    int year, [
    int width = 3,
  ]) {
    final List<List<List<DateTime>>> months = List<List<List<DateTime>>>.from(
      Month.values.map(
        (Month m) =>
            List<List<DateTime>>.from(monthDatesCalendar(year, m.value)),
      ),
    );

    return _range(
      0,
      months.length,
      width,
    ).map((int i) => months.sublist(i, i + width)).toList();
  }

  /// Return the data for the specified year ready for formatting (similar to [yearDatesCalendar()]).
  ///
  /// Entries in the week lists are `(day number, weekday number)` records. Day numbers outside this month are zero.
  List<List<List<List<(int d, int weekday)>>>> yearDays2Calendar(
    int year, [
    int width = 3,
  ]) {
    final List<List<List<(int, int)>>> months =
        List<List<List<(int, int)>>>.from(
          Month.values.map(
            (Month m) =>
                List<List<(int, int)>>.from(monthDays2Calendar(year, m.value)),
          ),
        );

    return _range(
      0,
      months.length,
      width,
    ).map((int i) => months.sublist(i, i + width)).toList();
  }

  /// Return the data for the specified year ready for formatting (similar to [yearDatesCalendar()]).
  ///
  /// Entries in the week lists are day numbers. Day numbers outside this month are zero.
  List<List<List<List<int>>>> yearDaysCalendar(int year, [int width = 3]) {
    final List<List<List<int>>> months = List<List<List<int>>>.from(
      Month.values.map(
        (Month m) => List<List<int>>.from(monthDaysCalendar(year, m.value)),
      ),
    );

    return _range(
      0,
      months.length,
      width,
    ).map((int i) => months.sublist(i, i + width)).toList();
  }
}

/// Subclass of [Calendar] that outputs a calendar as a simple plain text similar to the UNIX program `cal`.
final class TextCalendar extends Calendar {
  TextCalendar();

  // TODO implement method
  /// Print a single week (no newline).
  void prWeek(int theWeek, int width) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Returns a formatted day.
  String formatDay(int day, int weekday, int width) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Returns a single week in a string (no newline).
  String formatWeek(List<(int, int)> theWeek, int width) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Returns a formatted week day name.
  String formatWeekday(int day, int width) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Return a header for a week.
  String formatWeekHeader(int width) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Return a formatted month name.
  String formatMonthName(
    int theYear,
    int theMonth,
    int width, [
    bool withYear = true,
  ]) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Print a month's calendar.
  void prMonth(int theYear, int theMonth, [int w = 0, int l = 0]) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Return a month's calendar string (multi-line).
  String formatMonth(int theYear, int theMonth, [int w = 0, int l = 0]) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Returns a year's calendar as a multi-line string.
  String formatYear(int theYear, [w = 2, l = 1, c = 6, int m = 3]) {
    throw UnimplementedError();
  }

  // TODO implement method
  /// Print a year's calendar.
  void prYear(int theYear, [int w = 0, int l = 0, c = 6, int m = 3]) {
    throw UnimplementedError();
  }
}
