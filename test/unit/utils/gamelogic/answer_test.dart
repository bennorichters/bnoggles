// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/gamelogic/answer.dart' as solution;

import 'package:bnoggles/utils/gamelogic/lettter_sequence.dart';

class MockBoard extends Mock implements Board {}

void main() {
  test('uniqueWordsSorted', () {
    solution.Solution s = createSolution();
    expect(s.uniqueWordsSorted().toSet(), Set.of(<String>['ab', 'bc', 'dab']));
  });

  test('wordsPerSizeCount', () {
    var h = createSolution().frequency;
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
    var h = createSolution(minimalLength: 3).frequency;
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
    var a = solution.UserAnswer.start();
    expect(a.found.length, 0);

    a = a.add("abc", true);
    expect(a.found.length, 1);
    expect(a.found[0].word, "abc");
    expect(a.found[0].evaluation, solution.Evaluation.good);

    a = a.add("def", false);
    expect(a.found.length, 2);
    expect(a.found[0].word, "abc");
    expect(a.found[0].evaluation, solution.Evaluation.good);
    expect(a.found[1].word, "def");
    expect(a.found[1].evaluation, solution.Evaluation.wrong);

    a = a.add("abc", true);
    expect(a.found.length, 3);
    expect(a.found[0].word, "abc");
    expect(a.found[0].evaluation, solution.Evaluation.good);
    expect(a.found[1].word, "def");
    expect(a.found[1].evaluation, solution.Evaluation.wrong);
    expect(a.found[2].word, "abc");
    expect(a.found[2].evaluation, solution.Evaluation.goodAgain);
  });

  test('userAnswer.uniqueWords', () {
    solution.UserAnswer a = solution.UserAnswer.start();
    a = a.add("abc", true);
    a = a.add("def", false);
    a = a.add("abc", true);
    a = a.add("ghi", true);

    expect(a.uniqueWords(), ["abc", "ghi"].toSet());
  });

  test('toString does throw exception', () {
    createSolution().toString();
    solution.UserAnswer.start().toString();
    createSolution().chains.first.toString();
    solution.UserAnswer.start().add('abc', true).found[0].toString();
  });
}

class MockRandomLetterGenerator extends Mock implements SequenceGenerator {}

solution.Solution createSolution({int minimalLength = 2}) {
  var allCoordinates = [
    Coordinate(0, 0),
    Coordinate(0, 1),
    Coordinate(1, 0),
    Coordinate(1, 1)
  ];

  var rlg = MockRandomLetterGenerator();
  when(rlg.next()).thenAnswer((s) => 'a');
  Board realBoard = Board(
    width: 2,
    generator: rlg,
  );

  var mockBoard = MockBoard();
  when(mockBoard[allCoordinates[0]]).thenReturn('a');
  when(mockBoard[allCoordinates[1]]).thenReturn('b');
  when(mockBoard[allCoordinates[2]]).thenReturn('c');
  when(mockBoard[allCoordinates[3]]).thenReturn('d');

  when(mockBoard.width).thenReturn(2);

  when(mockBoard.allCoordinates()).thenReturn(allCoordinates);

  when(mockBoard.mapNeighbours()).thenReturn(realBoard.mapNeighbours());

  Dictionary dict = Dictionary(['ab', 'bc', 'dab', 'xyz']);

  return solution.Solution(mockBoard, dict, minimalLength);
}
