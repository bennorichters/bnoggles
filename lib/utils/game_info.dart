// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/cupertino.dart';

/// Information about an ongoing game
class GameInfo {
  /// Creates an instance of [GameInfo]
  GameInfo({
    @required this.parameters,
    @required this.board,
    @required this.solution,
    @required this.currentPlayer,
    @required this.allUserAnswers,
  }) : randomWords = solution.uniqueWords().toList()..shuffle();

  /// The [GameParameters]
  final GameParameters parameters;

  /// The [Board]
  final Board board;

  /// The [Solution]
  final Solution solution;

  /// The number of the player who is currently playing
  int currentPlayer;

  /// A list of [ValueNotifier]s holding a [UserAnswer] for each player
  final List<ValueNotifier<UserAnswer>> allUserAnswers;

  /// A list all unique words contained by [Solution] in a random order
  final List<String> randomWords;

  /// Returns the user answer for the current player
  ValueNotifier<UserAnswer> get userAnswer => allUserAnswers[currentPlayer];

  List<ScoreSheet> scoreSheets() => allUserAnswers
      .map((a) => ScoreSheet._(
            availableWords: solution.frequency.count,
            foundWords: a.value.frequency.count,
          ))
      .toList();

  /// Returns the [ScoreSheet] for the given player
  ScoreSheet scoreSheet(int player) => ScoreSheet._(
        availableWords: solution.frequency.count,
        foundWords: allUserAnswers[player].value.frequency.count,
      );

  /// Returns the the number of unique words the [solution] has.
  int availableWords() => solution.uniqueWords().length;

  /// Returns the number of found and correct words for each player.
  List<int> playersFoundCount() =>
      allUserAnswers.map((a) => a.value.uniqueWords().length).toList();

  /// Adds the listener for the element in [GameInfo.allUserAnswers] that has
  /// [currentPlayer] as the index.
  void addUserAnswerListener(VoidCallback listener) {
    allUserAnswers[currentPlayer].addListener(listener);
  }

  /// Removes the listener for the element in [GameInfo.allUserAnswers] that has
  /// [currentPlayer] as the index.
  void removeUserAnswerListener(VoidCallback listener) {
    allUserAnswers[currentPlayer].removeListener(listener);
  }
}

/// Information about the available and found words
class ScoreSheet {
  ScoreSheet._({this.availableWords, this.foundWords});

  /// The available words
  final int availableWords;

  /// The found words
  final int foundWords;
}
