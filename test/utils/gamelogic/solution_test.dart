import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';

class MockBoard extends Mock implements Board {}

void main() {
  test('uniqueWordsSorted', () {
    Solution s = createSolution();
    expect(s.uniqueWordsSorted().toSet(), Set.of(<String>['ab', 'bc', 'dab']));
  });

  test('wordsPerSizeCount', () {
    var h = createSolution().histogram;
    expect(h[0], 0);
    expect(h[1], 0);
    expect(h[2], 2);
    expect(h[3], 1);
    expect(h[4], 0);

    expect(h.atLeast(0), 3);
    expect(h.atLeast(1), 3);
    expect(h.atLeast(2), 3);
    expect(h.atLeast(3), 1);
    expect(h.atLeast(4), 0);
  });

  test('wordsPerSizeCount minimal Length = 3', () {
    var h = createSolution(minimalLength: 3).histogram;
    expect(h[0], 0);
    expect(h[1], 0);
    expect(h[2], 0);
    expect(h[3], 1);
    expect(h[4], 0);

    expect(h.atLeast(0), 1);
    expect(h.atLeast(1), 1);
    expect(h.atLeast(2), 1);
    expect(h.atLeast(3), 1);
    expect(h.atLeast(4), 0);
  });

  test('userAnswer.found', () {
    var a = UserAnswer.start();
    expect(a.found.length, 0);

    a = UserAnswer(a, "abc", true);
    expect(a.found.length, 1);
    expect(a.found[0].word, "abc");
    expect(a.found[0].eval, Evaluation.good);

    a = UserAnswer(a, "def", false);
    expect(a.found.length, 2);
    expect(a.found[0].word, "abc");
    expect(a.found[0].eval, Evaluation.good);
    expect(a.found[1].word, "def");
    expect(a.found[1].eval, Evaluation.wrong);

    a = UserAnswer(a, "abc", true);
    expect(a.found.length, 3);
    expect(a.found[0].word, "abc");
    expect(a.found[0].eval, Evaluation.good);
    expect(a.found[1].word, "def");
    expect(a.found[1].eval, Evaluation.wrong);
    expect(a.found[2].word, "abc");
    expect(a.found[2].eval, Evaluation.goodAgain);
  });

  test('userAnswer.uniqueWords', () {
    UserAnswer a = UserAnswer.start();
    a = UserAnswer(a, "abc", true);
    a = UserAnswer(a, "def", false);
    a = UserAnswer(a, "abc", true);
    a = UserAnswer(a, "ghi", true);

    expect(a.uniqueWords(), ["abc", "ghi"].toSet());
  });
}

class MockRandomLetterGenerator extends Mock implements RandomLetterGenerator {}

Solution createSolution({int minimalLength = 2}) {
  var allCoordinates = [
    Coordinate(0, 0),
    Coordinate(0, 1),
    Coordinate(1, 0),
    Coordinate(1, 1)
  ];

  var rlg = MockRandomLetterGenerator();
  when(rlg.next(maxLength: anyNamed('maxLength'))).thenAnswer((s) => 'a');
  Board realBoard = Board(2, rlg);

  var mockBoard = MockBoard();
  when(mockBoard.characterAt(allCoordinates[0])).thenReturn('a');
  when(mockBoard.characterAt(allCoordinates[1])).thenReturn('b');
  when(mockBoard.characterAt(allCoordinates[2])).thenReturn('c');
  when(mockBoard.characterAt(allCoordinates[3])).thenReturn('d');

  when(mockBoard.width).thenReturn(2);

  when(mockBoard.allCoordinates()).thenReturn(allCoordinates);

  when(mockBoard.mapNeighbours()).thenReturn(realBoard.mapNeighbours());

  Dictionary dict = Dictionary(['ab', 'bc', 'dab', 'xyz']);

  return Solution(mockBoard, dict, minimalLength);
}
