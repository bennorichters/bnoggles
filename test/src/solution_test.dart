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

    Map<int, int> wordsPerLengthCount = s.wordsPerLengthCount();

    expect(2, wordsPerLengthCount.keys.length);
    expect(2, wordsPerLengthCount[2]);
    expect(1, wordsPerLengthCount[3]);
  });
}

Solution createSolution() {
  var allCoords = [
    Coordinate(0, 0),
    Coordinate(0, 1),
    Coordinate(1, 0),
    Coordinate(1, 1)
  ];

  var b = MockBoard();
  when(b.characterAt(allCoords[0])).thenReturn('a');
  when(b.characterAt(allCoords[1])).thenReturn('b');
  when(b.characterAt(allCoords[2])).thenReturn('c');
  when(b.characterAt(allCoords[3])).thenReturn('d');

  when(b.width).thenReturn(2);

  when(b.allCoordinates()).thenReturn(allCoords);

  Dictionary dict = Dictionary(['ab', 'bc', 'dab', 'xyz']);

  Solution s = Solution(b, dict);
  return s;
}
