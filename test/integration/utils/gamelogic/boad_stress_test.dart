// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:trotter/trotter.dart';

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';

import 'package:bnoggles/utils/gamelogic/lettter_sequence.dart';

void main() {
  test('lot of shuffles', () {
    var info = LetterSequenceInfo({
      'abc': 1,
      'de': 1,
      'f': 1,
    });

    Dictionary dict = Dictionary(['12345']);

    int boardWidth = 3;
    for (int i = 0; i < factorial(boardWidth * boardWidth); i++) {
      var gen = info.createSequenceGenerator();
      Shuffler myShuffler = (List<Coordinate> list) =>
          Permutations(list.length, list)[i].cast<Coordinate>();

      var board = Board(
        width: boardWidth,
        generator: gen,
        shuffler: myShuffler,
        word: "12345",
      );

      expect(Solution(board, dict, 2).contains("12345"), true);
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
