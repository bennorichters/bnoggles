import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:bnoggles/screens/start/widgets/board_size_slider.dart';
import 'package:bnoggles/screens/start/widgets/settings.dart';
import 'package:bnoggles/screens/start/widgets/time_slider.dart';
import 'package:flutter/material.dart';

import 'package:bnoggles/utils/board.dart';
import 'package:bnoggles/utils/dictionary.dart';
import 'package:bnoggles/utils/solution.dart';

class StartScreen extends StatefulWidget {
  final RandomLetterGenerator generator;
  final Dictionary dictionary;

  StartScreen({Key key, @required this.generator, @required this.dictionary})
      : super(key: key);

  @override
  State createState() =>
      StartScreenState(generator: generator, dictionary: dictionary);
}

class StartScreenState extends State<StartScreen> {
  final RandomLetterGenerator generator;
  final Dictionary dictionary;

  int boardWidth = 3;
  ValueNotifier<int> time = ValueNotifier(150);

  StartScreenState({@required this.generator, @required this.dictionary});

  setBoardWidth(int value) {
    boardWidth = value;
  }

  setTime(int value) {
    time.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bnoggles"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SettingsGrid(time),
            Center(
              child: FloatingActionButton(
                onPressed: () {
                  var board = Board(boardWidth, generator);
                  var solution = Solution(board, dictionary);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GameScreen(
                              board: board,
                              solution: solution,
                              startValue: time.value,
                            )),
                  );
                },
                child: Icon(Icons.forward),
              ),
            ),
          ]),
    );
  }
}
