import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/game_board_grid.dart';
import 'package:bnoggles/screens/game/widgets/game_word_count_row.dart';
import 'package:bnoggles/screens/game/widgets/game_word_window.dart';
import 'package:bnoggles/screens/game/widgets/provider.dart';

import 'package:bnoggles/utils/board.dart';
import 'package:bnoggles/utils/solution.dart';

class GamePage extends StatelessWidget {
  final String title;
  final Board board;
  final Solution solution;

  GamePage(
      {Key key,
      @required this.title,
      @required this.board,
      @required this.solution})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Provider(
            immutableData: {"board": board, "solution": solution},
            mutableData: ValueNotifier(UserAnswer.start()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                WordCountRow(),
                WordWindow(),
                Grid(),
              ],
            )));
  }
}
