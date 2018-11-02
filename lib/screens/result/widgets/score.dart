// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScoreOverview extends StatelessWidget {
  final ScoreSheet scores;
  final double fontSize;

  ScoreOverview({Key key, @required this.scores, @required this.fontSize})
      : super(key: key);

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
          buildText('${scores.foundWords}', Colors.green),
          Container(
            width: 10.0,
          ),
          buildText('/', Colors.black),
          Container(
            width: 10.0,
          ),
          buildText('${scores.availableWords}', Colors.blue),
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
