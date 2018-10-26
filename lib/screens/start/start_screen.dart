import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:bnoggles/screens/start/widgets/settings.dart';
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

  ValueNotifier<int> time = ValueNotifier(150);
  ValueNotifier<int> size = ValueNotifier(3);
  ValueNotifier<int> length = ValueNotifier(2);

  StartScreenState({@required this.generator, @required this.dictionary});

  setBoardWidth(int value) {
    size.value = value;
  }

  setTime(int value) {
    time.value = value;
  }
  setLength(int value) {
    length.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bnoggles"),
      ),
      body: Center(child: Container(
        width: 500.0,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SettingsGrid(time, size, length),
            Center(
              child: FloatingActionButton(
                onPressed: () {
                  var board = Board(size.value, generator);
                  var solution = Solution(board, dictionary, length.value);

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
          ]))),
    );
  }
}
