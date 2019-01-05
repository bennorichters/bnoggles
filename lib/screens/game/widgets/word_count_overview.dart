// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/game_info_provider.dart';

import 'package:bnoggles/utils/gamelogic/solution.dart';

const int _maxLength = 8;

/// Overview of word lengths and the number of words still to be find in this
/// category by the user.
///
/// This widget should be a descendant of [GameInfoProvider].
class WordCountOverview extends StatelessWidget {
  /// Creates a [WordCountOverview]
  const WordCountOverview({this.fontSize});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    Solution solution = GameInfoProvider.of(context).solution;

    return GridView.builder(
      itemCount: ((_maxLength - 1) * 2),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (_maxLength - 1),
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: fromIndex(index, solution),
          ),
    );
  }

  Widget fromIndex(int index, Solution solution) {
    int rowSize = (_maxLength - 1);
    int lastIndexRow1 = rowSize - 1;

    int length = (index % (_maxLength - 1)) + 2;

    if (index <= lastIndexRow1) {
      String text = length.toString();
      if (length == _maxLength) {
        text = ">= " + text;
      }
      return _NumberInfo(text, index, fontSize);
    }
    if (length < solution.minimalLength) {
      return _NoNumberInfo(index, fontSize);
    }
    return _UserAnswerNumberInfo(length, index, fontSize);
  }
}

class _NumberInfo extends StatelessWidget {
  const _NumberInfo(this.number, this.index, this.fontSize);
  final String number;
  final int index;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Container(
        key: Key('wordcount' + index.toString()),
        color: Colors.blueGrey,
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              color: Colors.white70,
              fontSize: fontSize,
            ),
          ),
        ),
      );
}

class _NoNumberInfo extends StatelessWidget {
  const _NoNumberInfo(this.index, this.fontSize);
  final int index;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Container(
        key: Key('wordcount' + index.toString()),
        color: Colors.blueGrey,
        child: Center(
          child: Text(
            'x',
            style: TextStyle(
              color: Colors.white70,
              fontSize: fontSize,
            ),
          ),
        ),
      );
}

class _UserAnswerNumberInfo extends StatelessWidget {
  const _UserAnswerNumberInfo(this.length, this.index, this.fontSize);
  final int length;
  final int index;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    var gameInfo = GameInfoProvider.of(context);
    Solution solution = gameInfo.solution;
    Answer answer = gameInfo.userAnswer.value;

    var todo = solution.frequency - answer.frequency;
    int remaining = length == _maxLength ? todo.atLeast(length) : todo[length];

    return Container(
      key: Key('wordcount' + index.toString()),
      color: Colors.blue,
      child: Center(
        child: Text(
          remaining.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
