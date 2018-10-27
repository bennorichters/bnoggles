import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:bnoggles/screens/start/widgets/settings.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter/material.dart';

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/configuration.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';

class StartScreen extends StatefulWidget {
  final Configuration configuration;

  StartScreen({Key key, @required this.configuration}) : super(key: key);

  @override
  State createState() => StartScreenState(configuration: configuration);
}

class StartScreenState extends State<StartScreen> {
  final Configuration configuration;

  StartScreenState({@required this.configuration});

  void setBoardWidth(int value) {
    configuration.preferences.size.value = value;
  }

  void setTime(int value) {
    configuration.preferences.time.value = value;
  }

  void setLength(int value) {
    configuration.preferences.length.value = value;
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
                    SettingsGrid(
                        configuration.preferences.time,
                        configuration.preferences.size,
                        configuration.preferences.length),
                    Center(
                      child: FloatingActionButton(
                        onPressed: () {
                          var board = Board(
                              configuration.preferences.size.value,
                              configuration.generator);

                          var solution = Solution(
                              board,
                              configuration.dictionary,
                              configuration.preferences.length.value);

                          GameInfo gameInfo = GameInfo(
                              configuration: configuration,
                              board: board,
                              solution: solution,
                              userAnswer: ValueNotifier(UserAnswer.start()));

                          Navigator.push(
                            context,
                            MaterialPageRoute<Null>(
                                builder: (context) => GameScreen(
                                      gameInfo: gameInfo,
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
