import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:bnoggles/src/board.dart';
import 'package:bnoggles/src/coordinate.dart';
import 'package:bnoggles/src/dictionary.dart';

class MockRandomLetterGenerator extends Mock implements RandomLetterGenerator {}

void main() {

  test('all characters', () {
    var rlg = MockRandomLetterGenerator();
    var letters = ['a', 'b', 'c', 'd'];

    when(rlg.next()).thenAnswer((s) => letters.removeAt(0));

    Board b = Board(2, rlg);

    Set allChars = Set();
    allChars.add(b.characterAt(Coordinate(0,0)));
    allChars.add(b.characterAt(Coordinate(0,1)));
    allChars.add(b.characterAt(Coordinate(1,0)));
    allChars.add(b.characterAt(Coordinate(1,1)));

    expect(allChars, Set.from(['a', 'b', 'c', 'd']));
  });
}
