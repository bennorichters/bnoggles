// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_clock.dart';
import 'package:bnoggles/screens/game/widgets/game_score.dart';
import 'package:bnoggles/screens/game/widgets/word_count_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// An overview of the progress of the game.
///
/// This widget creates a [Row] and within that Row a [Clock] and a
/// [WordCountOverview].
///
/// This widget should be a descendant of [Provider].
class GameProgress extends StatelessWidget {
  GameProgress({
    @required this.blockHeight,
    @required this.wordCountFontSize,
    @required this.timeWidget,
  });

  final double blockHeight;
  final double wordCountFontSize;
  final Widget timeWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: blockHeight * 7,
          height: blockHeight * 2,
          child: WordCountOverview(
            fontSize: wordCountFontSize,
          ),
        ),
        Expanded(
          child: Container(
            height: blockHeight * 2,
            child: Column(
              children: [
                Container(
                  height: blockHeight,
                  child: timeWidget,
                ),
                GameScore(
                  height: blockHeight,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
