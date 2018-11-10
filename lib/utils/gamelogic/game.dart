// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/gamelogic/lettter_sequence.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';

/// A container for both a [Board] and a [Solution].
///
/// The board and the solution are created by the constructor.
class Game {

  /// The [Board]
  final Board board;

  /// The [Solution]
  final Solution solution;

  Game._(this.board, this.solution);

  /// Creates a [Board] and a [Solution] to be contained by the new game.
  ///
  /// The new board has width [boardWidth] and is filled with letters generated
  /// by the [generator]. The solution is then created based on the given
  /// [dictionary] and [minimalWordLength].
  ///
  /// It is guaranteed that the generated board has a solution that contains at
  /// least one word.
  factory Game(int boardWidth, SequenceGenerator generator,
      Dictionary dictionary, int minimalWordLength) {
    Board board = Board(
      boardWidth,
      generator,
    );

    Solution solution = Solution(
      board,
      dictionary,
      minimalWordLength,
    );

    if (solution.uniqueWords().length < 10) {
      String word = dictionary.randomWord(4);
      board = board.insertWordRandomly(word);

      solution = Solution(
        board,
        dictionary,
        minimalWordLength,
      );
    }

    return Game._(board, solution);
  }
}
