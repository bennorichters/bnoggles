// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_clock.dart';
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
  GameProgress(this._controller, this._startValue, this._showResultScreen);

  final AnimationController _controller;
  final int _startValue;
  final VoidCallback _showResultScreen;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 280.0,
            height: 80.0,
            child: const WordCountOverview(),
          ),
          Expanded(
            child: Container(
              height: 80.0,
              child: Clock(_showResultScreen, _controller, _startValue),
            ),
          ),
        ],
      );
}
