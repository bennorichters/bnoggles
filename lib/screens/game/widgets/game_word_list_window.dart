// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_word_list.dart';
import 'package:bnoggles/screens/game/widgets/game_info_provider.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:flutter/material.dart';

/// A column of one or two [WordList]s
///
/// The first word list shows the words found by the user as contained by
/// [GameInfo.userAnswer]. If [GameInfo.parameters.hints] is [true] a second
/// WordList is created to show all correct words in a random order.
class WordListWindow extends StatelessWidget {
  /// Creates a WordListWindow.
  const WordListWindow();

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    double screenHeight = data.size.height;

    GameInfo gameInfo = GameInfoProvider.of(context);

    return ValueListenableBuilder<UserAnswer>(
        valueListenable: gameInfo.userAnswer,
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: wordLines(gameInfo, screenHeight),
          );
        });
  }

  List<Widget> wordLines(GameInfo gameInfo, double screenHeight) {
    WordList userWordList = WordList(
      words: gameInfo.userAnswer.value.found.reversed
          .map((a) => WordDisplay.fromUser(
                userWord: a,
                screenHeight: screenHeight,
              ))
          .toList(),
      scrollBackOnUpdate: true,
    );

    if (!gameInfo.parameters.hints) {
      return [userWordList];
    }

    return [
      userWordList,
      WordList(
        words: gameInfo.randomWords
            .where((w) =>
                !gameInfo.userAnswer.value.found.map((w) => w.word).contains(w))
            .map((a) => WordDisplay.neutral(
                  word: a,
                  screenHeight: screenHeight,
                ))
            .toList(),
        scrollBackOnUpdate: false,
      ),
    ];
  }
}
