import 'package:calendar_dart/calendar.dart';
import 'package:test/test.dart';

const List<int> starts = [0, 1, 2, 10, 20];

void main() {
  late Iterable<int> Function(int, [int, int]) r;

  setUp(() async {
    r = range;
  });

  group('range()', () {
    // TODO add more tests for start arg
    group('start', () {
      for (int start in starts) {
        test('($start)', () {
          final List<int> expected = List<int>.generate(start, (int i) => i);
          List output = r(start).toList();

          expect(output, equals(expected));
        });
      }
    });

    // TODO add tests for start and stop args
    group('start, stop', () {});

    // TODO add tests for start, stop and step args
    group('start, stop, step', () {});
  });
}
