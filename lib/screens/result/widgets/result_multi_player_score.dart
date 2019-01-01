// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MultiPlayerScore extends StatelessWidget {
  MultiPlayerScore({
    Key key,
    @required this.scores,
    @required this.fontSize,
  }) : super(key: key);

  final List<ScoreSheet> scores;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.done_all,
              size: 30.0,
              color: Colors.black,
            ),
            Text(
              scores[0].availableWords.toString(),
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        Container(
          height: 5,
        ),
        Table(
          columnWidths: {
            0: FixedColumnWidth(50.0),
            1: FixedColumnWidth(50.0),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Icon(Icons.person, size: 20,),
              Icon(Icons.done, size: 20, ),
            ])
          ]..addAll(playerScores()),
        )
      ],
    );
  }

  List<TableRow> playerScores() {
    var asMap = scores.asMap();
    return (asMap.keys.toList()..sort())
        .reversed
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
                    asMap[k].foundWords.toString(),
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
