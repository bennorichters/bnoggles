// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:test/test.dart';
import 'package:trotter/trotter.dart';

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';

import 'package:bnoggles/utils/gamelogic/lettter_frequency.dart';

void main() {
  test('lot of shuffles', () {
    var info = LetterFrequencyInfo({
      'abc': 1,
      'de': 1,
      'f': 1,
    });

    Dictionary dict = Dictionary(['word']);

    int boardWidth = 3;
    for (int i = 0; i < factorial(boardWidth * boardWidth); i++) {
      var gen = LetterGenerator(info);
      Shuffler myShuffler = (List<Coordinate> list) =>
          Permutations(list.length, list)[i].cast<Coordinate>();

      var board = Board(boardWidth, gen, myShuffler).insertWordRandomly("word");
      expect(Solution(board, dict, 2).contains("word"), true);
    }
  });
}

int factorial(int number) {
  int result = 1;
  for (int i = 2; i <= number; i++) {
    result *= i;
  }

  return result;
}
