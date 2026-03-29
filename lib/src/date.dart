/// Simplified version of DateTime for storing just a calendar date.
class Date extends DateTime {
  Date(super.year, super.month, super.day);

  Date.fromDateTime(DateTime date) : super(date.year, date.month, date.day);

  /// Emulates printing a Python `datetime.date`.
  String toPythonString() => 'datetime.date($year, $month, $day)';

  @override
  String toString() => 'Date($year, $month, $day)';
}
