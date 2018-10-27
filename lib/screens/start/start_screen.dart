import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:bnoggles/screens/start/widgets/settings.dart';
import 'package:flutter/material.dart';

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/configuration.dart';
import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';

class StartScreen extends StatefulWidget {
  final Configuration configuration;

  StartScreen({Key key, @required this.configuration}) : super(key: key);

  @override
  State createState() => StartScreenState(config: configuration);
}

class StartScreenState extends State<StartScreen> {
  final RandomLetterGenerator generator;
  final Dictionary dictionary;
  final Preferences prefs;

  StartScreenState({@required Configuration config})
      : prefs = config.preferences,
        dictionary = config.dictionary,
        generator = config.generator;

  void setBoardWidth(int value) {
    prefs.size.value = value;
  }

  void setTime(int value) {
    prefs.time.value = value;
  }

  void setLength(int value) {
    prefs.length.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bnoggles"),
      ),
      body: Center(
          child: Container(
              width: 500.0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SettingsGrid(prefs.time, prefs.size, prefs.length),
                    Center(
                      child: FloatingActionButton(
                        onPressed: () {
                          var board = Board(prefs.size.value, generator);
                          var solution =
                              Solution(board, dictionary, prefs.length.value);

                          Navigator.push(
                            context,
                            MaterialPageRoute<Null>(
                                builder: (context) => GameScreen(
                                      board: board,
                                      solution: solution,
                                      startValue: prefs.time.value,
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
