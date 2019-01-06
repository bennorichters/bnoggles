// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:bnoggles/utils/widget_logic/widget_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final _fontSizeCalculator = Interpolator.fromDataPoints(
  p1: const Point(592, 15),
  p2: const Point(1224, 35),
  min: 10,
  max: 40,
);

final _iconSizeCalculator = Interpolator.fromDataPoints(
  p1: const Point(592, 20),
  p2: const Point(1224, 45),
  min: 15,
  max: 50,
);

/// Screen showing the results for all players.
class ResultMultiPlayerScore extends StatelessWidget {
  ResultMultiPlayerScore({
    Key key,
    @required this.availableWordsCount,
    @required this.foundWords,
    @required this.maxScore,
    @required this.scores,
  }) : super(key: key);

  final int availableWordsCount;
  final List<int> foundWords;
  final int maxScore;
  final List<int> scores;

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    double screenHeight = data.size.height;

    double fontSize = _fontSizeCalculator.y(x: screenHeight);
    double iconSize = _iconSizeCalculator.y(x: screenHeight);

    return Table(
      columnWidths: const {
        0: FixedColumnWidth(50.0),
        1: FixedColumnWidth(50.0),
        2: FixedColumnWidth(100.0),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          Icon(
            Icons.done_all,
            size: iconSize + 5,
            color: Colors.black,
          ),
          totalText(availableWordsCount, fontSize),
          totalText(maxScore, fontSize),
        ]),
        TableRow(children: [
          Icon(
            Icons.person,
            size: iconSize,
          ),
          Icon(
            Icons.done,
            size: iconSize,
          ),
          Icon(
            Icons.flag,
            size: iconSize,
          ),
        ])
      ]..addAll(playerScores(fontSize)),
    );
  }

  Widget totalText(int number, double fontSize) {
    return Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        );
  }

  List<TableRow> playerScores(double fontSize) {
    Map<int, int> asMap = scores.asMap();
    return (asMap.keys.toList()..sort((a, b) => asMap[b] - asMap[a]))
        .map((k) => TableRow(
              children: [
                Center(
                  child: Text(
                    (k + 1).toString(),
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    foundWords[k].toString(),
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.green,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    scores[k].toString(),
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ))
        .toList();
  }
}
