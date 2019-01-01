// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:bnoggles/screens/game/widgets/game_clock.dart';
import 'package:bnoggles/screens/game/widgets/word_count_overview.dart';
import 'package:bnoggles/utils/widget_logic/widget_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final _blockHeightCalculator = Interpolator.fromDataPoints(
  p1: const Point(592, 25),
  p2: const Point(683.4, 40),
  min: 25,
  max: 40,
);

final _fontSizeCalculator = Interpolator.fromDataPoints(
  p1: const Point(592, 10),
  p2: const Point(683.4, 14),
  min: 8,
  max: 14,
);

/// An overview of the progress of the game.
///
/// This widget creates a [Row] and within that Row a [Clock] and a
/// [WordCountOverview].
///
/// This widget should be a descendant of [Provider].
class GameProgress extends StatelessWidget {
  GameProgress({this.timeWidget});
  final Widget timeWidget;

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    double screenHeight = data.size.height;
    double blockHeight = _blockHeightCalculator.y(x: screenHeight);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: blockHeight * 7,
          height: blockHeight * 2,
          child: WordCountOverview(
            fontSize: _fontSizeCalculator.y(
              x: screenHeight,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: blockHeight * 2,
            child: timeWidget,
          ),
        ),
      ],
    );
  }
}
