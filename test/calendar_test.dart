import 'package:calendar_dart/calendar.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final Calendar cal = Calendar();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(cal.firstWeekDay, 0);
    });
  });
}
