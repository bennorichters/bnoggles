import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:bnoggles/src/board.dart';
import 'package:bnoggles/src/coordinate.dart';
import 'package:bnoggles/src/dictionary.dart';
import 'package:bnoggles/src/solution.dart';

class MockBoard extends Mock implements Board {}

void main() {
  test('', () {
    Solution s = createSolution();
    expect(s.uniqueWordsSorted().toSet(), Set.from(['ab', 'bc', 'dab']));
  });

  test('wordsPerSizeCount', () {
    Solution s = createSolution();

    expect(0, s.countForLength(0));
    expect(0, s.countForLength(1));
    expect(2, s.countForLength(2));
    expect(1, s.countForLength(3));
    expect(0, s.countForLength(4));

    expect(3, s.countForMinLength(0));
    expect(3, s.countForMinLength(1));
    expect(3, s.countForMinLength(2));
    expect(1, s.countForMinLength(3));
    expect(0, s.countForMinLength(4));
  });
}

Solution createSolution() {
  var allCoordinates = [
    Coordinate(0, 0),
    Coordinate(0, 1),
    Coordinate(1, 0),
    Coordinate(1, 1)
  ];

  var b = MockBoard();
  when(b.characterAt(allCoordinates[0])).thenReturn('a');
  when(b.characterAt(allCoordinates[1])).thenReturn('b');
  when(b.characterAt(allCoordinates[2])).thenReturn('c');
  when(b.characterAt(allCoordinates[3])).thenReturn('d');

  when(b.width).thenReturn(2);

  when(b.allCoordinates()).thenReturn(allCoordinates);

  Dictionary dict = Dictionary(['ab', 'bc', 'dab', 'xyz']);

  return Solution(b, dict);
}
