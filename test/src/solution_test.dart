import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:bnoggles/src/board.dart';
import 'package:bnoggles/src/coordinate.dart';
import 'package:bnoggles/src/dictionary.dart';
import 'package:bnoggles/src/solution.dart';

class MockBoard extends Mock implements Board {}

void main() {
  test('', () {
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

    Dictionary dict = Dictionary(['bc', 'dab', 'xyz']);

    Solution s = Solution(b, dict);
    expect(s.uniqueWords().toSet(), Set.from(['bc', 'dab']));
  });
}
