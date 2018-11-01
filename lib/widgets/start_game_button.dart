import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:bnoggles/utils/language.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/material.dart';

class StartGameButton extends StatelessWidget {
  final ParameterProvider parameterProvider;
  final bool replaceScreen;

  StartGameButton(
      {Key key, @required this.parameterProvider, @required this.replaceScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "playgame",
      onPressed: () {
        var parameters = parameterProvider();
        Language.forLanguageCode(parameters.languageCode).then((language) {
          var game = language.createGame(
            parameters.size,
            parameters.length,
          );

          GameInfo gameInfo = GameInfo(
            parameters: parameters,
            board: game.board,
            solution: game.solution,
            userAnswer: ValueNotifier(UserAnswer.start()),
          );
          if (replaceScreen) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<Null>(
                builder: (context) => GameScreen(
                      gameInfo: gameInfo,
                    ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute<Null>(
                builder: (context) => GameScreen(
                      gameInfo: gameInfo,
                    ),
              ),
            );
          }
        });
      },
      child: Icon(Icons.play_arrow),
    );
  }
}
