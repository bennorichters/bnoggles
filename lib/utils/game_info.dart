import 'package:bnoggles/utils/configuration.dart';
import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:flutter/cupertino.dart';

class GameInfo {
  final Configuration configuration;
  final Board board;
  final Solution solution;
  final ValueNotifier<UserAnswer> userAnswer;
  bool gameOngoing;

  GameInfo(
      {@required this.configuration,
      @required this.board,
      @required this.solution,
      @required this.userAnswer,
      this.gameOngoing = true});

  void addListener(VoidCallback listener) {
    userAnswer.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    userAnswer.removeListener(listener);
  }
}
