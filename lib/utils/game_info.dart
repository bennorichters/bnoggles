// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/cupertino.dart';

/// Information about an ongoing game.
class GameInfo {
  /// Creates an instance of [GameInfo]
  GameInfo({
    @required this.parameters,
    @required this.board,
    @required Solution solution,
    @required this.userAnswer,
  })  : this.solution = solution,
        randomWords = solution.uniqueWords().toList()..shuffle();

  /// The [GameParameters]
  final GameParameters parameters;

  /// The [Board]
  final Board board;

  /// The [Solution]
  final Solution solution;

  /// A [ValueNotifier] holding a [userAnswer].
  final ValueNotifier<UserAnswer> userAnswer;

  /// A list of random word shown as hints.
  final List<String> randomWords;

  /// Returns the [ScoreSheet]
  ScoreSheet get scoreSheet => ScoreSheet(
        availableWords: solution.frequency.count,
        foundWords: userAnswer.value.frequency.count,
      );

  /// Adds a listener for the [GameInfo.userAnswer]
  void addUserAnswerListener(VoidCallback listener) {
    userAnswer.addListener(listener);
  }

  /// Removes a listener for the [GameInfo.userAnswer]
  void removeUserAnswerListener(VoidCallback listener) {
    userAnswer.removeListener(listener);
  }
}

/// Information about the available and found words
class ScoreSheet {
  /// Creates an instance of [ScoreSheet]
  ScoreSheet({this.availableWords, this.foundWords});

  /// The available words
  final int availableWords;

  /// The found words
  final int foundWords;
}
