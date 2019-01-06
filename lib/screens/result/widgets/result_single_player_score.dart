// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Overview of number found words by user and number total words
class ResultSinglePlayerScore extends StatelessWidget {
  /// Creates an instance of [ResultSinglePlayerScore]
  ResultSinglePlayerScore({
    Key key,
    @required this.foundWords,
    @required this.availableWordsCount,
    @required this.score,
    @required this.maxScore,
    @required this.fontSize,
  }) : super(key: key);

  final int foundWords;
  final int availableWordsCount;
  final int score;
  final int maxScore;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(90.0),
        1: FixedColumnWidth(50.0),
        2: FixedColumnWidth(110.0),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            Container(),
            const Icon(
              Icons.person,
              size: 40.0,
              color: Colors.black,
            ),
            const Icon(
              Icons.done_all,
              size: 40.0,
              color: Colors.black,
            ),
          ],
        ),
        TableRow(
          children: [
            const Icon(
              Icons.done,
              size: 40.0,
              color: Colors.black,
            ),
            buildText('$foundWords', Colors.green),
            buildText('$availableWordsCount', Colors.blue),
          ],
        ),
        TableRow(
          children: [
            const Icon(
              Icons.flag,
              size: 40.0,
              color: Colors.black,
            ),
            buildText('$score', Colors.green),
            buildText('$maxScore', Colors.blue),
          ],
        ),
      ],
    );
  }

  Widget buildText(String text, Color color) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: color,
        ),
      ),
    );
  }
}
