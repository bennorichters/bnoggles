import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:bnoggles/utils/configuration.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:flutter/material.dart';

class StartGameButton extends StatelessWidget {
  final Configuration configuration;

  StartGameButton({Key key, @required this.configuration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "playgame",
      onPressed: () {
        var parameters = configuration.preferences.toParameters();
        var board = Board(
          parameters.size,
          configuration.generator,
        );

        var solution = Solution(
          board,
          configuration.dictionary,
          parameters.length,
        );

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
                ),
          ),
        );
      },
      child: Icon(Icons.forward),
    );
  }
}
