import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:bnoggles/utils/gamelogic/scoring.dart' as sc;
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/cupertino.dart';

class GameInfo {
  final GameParameters parameters;
  final Board board;
  final Solution solution;
  final ValueNotifier<UserAnswer> userAnswer;
  final List<String> randomWords;

  GameInfo({
    @required this.parameters,
    @required this.board,
    @required Solution solution,
    @required this.userAnswer,
  })  : this.solution = solution,
        randomWords = solution.uniqueWords().toList()..shuffle();

  ScoreSheet get scoreSheet => ScoreSheet(
        availableWords: solution.histogram.count,
        foundWords: userAnswer.value.histogram.count,
        score: sc.standard(solution.histogram, userAnswer.value.histogram),
      );

  void addListener(VoidCallback listener) {
    userAnswer.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    userAnswer.removeListener(listener);
  }
}

class ScoreSheet {
  final int availableWords;
  final int foundWords;
  final int score;

  ScoreSheet({this.availableWords, this.foundWords, this.score});
}
