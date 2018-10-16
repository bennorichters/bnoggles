import 'package:bnoggles/screens/game/widgets/game_clock.dart';
import 'package:bnoggles/screens/game/widgets/game_word_count_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GameProgress extends StatelessWidget {
  final AnimationController _controller;
  final int _startValue;
  final _showResultScreen;

  GameProgress(this._controller, this._startValue, this._showResultScreen);

  @override
  build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 350.0, height: 100.0, child: WordCountOverview()),
      Expanded(
          child: Container(
              height: 100.0,
              child: Clock(_showResultScreen, _controller, _startValue))),
    ]);
  }
}
