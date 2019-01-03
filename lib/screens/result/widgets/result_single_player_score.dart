// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Overview of number found words by user and number total words
class ResultSinglePlayerScore extends StatelessWidget {
  /// Creates an instance of [ResultSinglePlayerScore]
  ResultSinglePlayerScore({
    Key key,
    @required this.maxScore,
    @required this.score,
    @required this.fontSize,
  }) : super(key: key);

  final int maxScore;
  final int score;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.done,
            size: 40.0,
            color: Colors.black,
          ),
          Container(
            width: 20.0,
          ),
          buildText('$score', Colors.green),
          Container(
            width: 10.0,
          ),
          buildText('/', Colors.black),
          Container(
            width: 10.0,
          ),
          buildText('$maxScore', Colors.blue),
        ],
      );

  Text buildText(String text, Color color) => Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: color,
        ),
      );
}
