import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:flutter/material.dart';

import 'package:bnoggles/utils/board.dart';
import 'package:bnoggles/utils/dictionary.dart';
import 'package:bnoggles/utils/solution.dart';

class StartScreen extends StatelessWidget {
  final RandomLetterGenerator generator;
  final Dictionary dictionary;

  StartScreen(
      {Key key,
        @required this.generator,
        @required this.dictionary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bnoggles"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            var board = Board(3, generator);
            var solution = Solution(board, dictionary);

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      GameScreen(board: board, solution: solution)),
            );
          },
          child: Text('>'),
        ),
      ),
    );
  }
}
