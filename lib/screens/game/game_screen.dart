import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/game_board_grid.dart';
import 'package:bnoggles/screens/game/widgets/game_progress.dart';
import 'package:bnoggles/screens/game/widgets/game_word_window.dart';
import 'package:bnoggles/widgets/provider.dart';

import 'package:bnoggles/utils/board.dart';
import 'package:bnoggles/utils/solution.dart';

class GameScreen extends StatelessWidget {
  final Board board;
  final Solution solution;

  GameScreen(
      {Key key,
      @required this.board,
      @required this.solution})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Bnoggles"),
        ),
        body: Provider(
            immutableData: {"board": board, "solution": solution},
            mutableData: ValueNotifier(UserAnswer.start()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GameProgress(),
                WordWindow(),
                Grid(),
              ],
            )));
  }
}
