// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/result/widgets/result_all_words_list.dart';
import 'package:bnoggles/screens/result/widgets/result_action_row.dart';
import 'package:bnoggles/screens/result/widgets/result_board.dart';
import 'package:bnoggles/screens/result/widgets/result_multi_player_score.dart';
import 'package:bnoggles/screens/result/widgets/result_single_player_score.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/frequency.dart';
import 'package:bnoggles/utils/gamelogic/score.dart';
import 'package:flutter/material.dart';

const Map<int, TableColumnWidth> _columnWidths = {
  0: FixedColumnWidth(50.0),
  1: FixedColumnWidth(50.0),
  2: FixedColumnWidth(100.0),
};

/// Screen showing [ResultAllWordsList], [ResultSinglePlayerScore], [ResultBoard]
/// and [ResultActionRow].
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

    GameInfo gameInfo = widget.gameInfo;

    double cellWidth = secondColumnWidth / gameInfo.board.width;

    Frequency solutionFrequency = gameInfo.solution.frequency;
    int availableWordsCount = gameInfo.availableWordsCount();
    int maxScore = calculateScore(solutionFrequency, availableWordsCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bnoggles'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              width: wordViewWidth,
              child: ResultAllWordsList(
                solution: gameInfo.solution,
                userAnswers:
                    gameInfo.allUserAnswers.map((v) => v.value).toList(),
                highlightedTiles: highlightedTiles,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: gameInfo.parameters.numberOfPlayers == 1
                          ? ResultSinglePlayerScore(
                              availableWordsCount: availableWordsCount,
                              foundWords: gameInfo.currentPlayerFoundCount(),
                              maxScore: maxScore,
                              score: calculateScore(
                                  gameInfo.userAnswer.value.frequency,
                                  availableWordsCount),
                              fontSize: secondColumnWidth / 20,
                              columnWidths: _columnWidths,
                            )
                          : ResultMultiPlayerScore(
                              availableWordsCount: availableWordsCount,
                              foundWords: gameInfo.playersFoundCount(),
                              maxScore: maxScore,
                              scores: gameInfo.allUserAnswers
                                  .map((a) => calculateScore(
                                      a.value.frequency, availableWordsCount))
                                  .toList(),
                              columnWidths: _columnWidths,
                            ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    child: ResultBoard(
                      board: gameInfo.board,
                      highlightedTiles: highlightedTiles,
                      cellWidth: cellWidth,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: ResultActionRow(
                      parameters: () => gameInfo.parameters,
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
