// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_info_provider.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/score.dart';
import 'package:flutter/material.dart';

const Color _shade100LightBlueAccent = Color(0xFF80D8FF);

/// A widget showing the current score of the current player
///
/// This widget should be a descendant of [GameInfoProvider].
class GameScore extends StatelessWidget {
  GameScore({@required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    GameInfo gameInfo = GameInfoProvider.of(context);

    int score = calculateScore(
        gameInfo.userAnswer.value.frequency, gameInfo.solution.frequency.count);

    return Container(
      height: height,
      color: _shade100LightBlueAccent,
      child: Center(
        child: Text(
          score.toString(),
          style: TextStyle(
            fontSize: height * .7,
            fontFamily: 'Inconsolata',
          ),
        ),
      ),
    );
  }
}
