// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/result/widgets/result_all_words_list.dart';
import 'package:bnoggles/screens/result/widgets/result_action_row.dart';
import 'package:bnoggles/screens/result/widgets/result_board.dart';
import 'package:bnoggles/screens/result/widgets/result_score_overview.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:flutter/material.dart';

/// Screen showing [ResultAllWordsList], [ResultScoreOverview], [ResultBoard] and
/// [ResultActionRow].
class ResultScreen extends StatefulWidget {
  /// Creates an instance of [ResultScreen].
  ResultScreen({@required this.gameInfo});

  final GameInfo gameInfo;

  @override
  State<StatefulWidget> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  ValueNotifier<List<Coordinate>> highlightedTiles = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double wordViewWidth = mediaWidth / 6;
    double secondColumnWidth = mediaWidth - wordViewWidth;
    double cellWidth = secondColumnWidth / widget.gameInfo.board.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Bnoggles"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              width: wordViewWidth,
              child: ResultAllWordsList(
                solution: widget.gameInfo.solution,
                userAnswer: widget.gameInfo.userAnswer.value,
                highlightedTiles: highlightedTiles,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: ResultScoreOverview(
                        scores: widget.gameInfo.scoreSheet,
                        fontSize: secondColumnWidth / 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    child: ResultBoard(
                      board: widget.gameInfo.board,
                      highlightedTiles: highlightedTiles,
                      cellWidth: cellWidth,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: ResultActionRow(
                      parameters: () => widget.gameInfo.parameters,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
