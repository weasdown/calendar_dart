/// Simplified version of DateTime for storing just a calendar date.
class Date extends DateTime {
  Date(super.year, super.month, super.day);

  Date.fromDateTime(DateTime date) : super(date.year, date.month, date.day);

  /// Emulates printing a Python `datetime.date`.
  String toPythonString() => 'datetime.date($year, $month, $day)';

  @override
  String toString() => 'Date($year, $month, $day)';
}

extension WDDateString on List<DateTime> {
  List<String> toPythonString() => List<String>.from(
    map((DateTime day) => Date.fromDateTime(day).toPythonString()),
  );
}

extension MWDDateString on List<List<DateTime>> {
  List<List<String>> toPythonString() =>
      map((List<DateTime> week) => week.toPythonString()).toList();
}

extension MsWDDateString on List<List<List<DateTime>>> {
  List<List<List<String>>> toPythonString() =>
      map((List<List<DateTime>> month) => month.toPythonString()).toList();
}

extension YMWDDateString on List<List<List<List<DateTime>>>> {
  List<List<List<List<String>>>> toPythonString() => map(
    (List<List<List<DateTime>>> months) => months.toPythonString(),
  ).toList();
}
