// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:bnoggles/screens/player/player_screen.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/game.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:bnoggles/utils/language.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/material.dart';

/// Button to start the game with
class StartGameButton extends StatefulWidget {
  StartGameButton({
    Key key,
    @required this.parameterProvider,
    @required this.replaceScreen,
  }) : super(key: key);

  final ParameterProvider parameterProvider;
  final bool replaceScreen;

  @override
  State<StatefulWidget> createState() => _StartGameButtonState();
}

class _StartGameButtonState extends State<StartGameButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: isLoading
          ? const CircularProgressIndicator()
          : FloatingActionButton(
              heroTag: "playgame",
              onPressed: _pressPlayButton(context),
              child: Icon(Icons.play_arrow),
            ),
    );
  }

  VoidCallback _pressPlayButton(BuildContext context) => () {
        setState(() {
          isLoading = true;
        });

        GameParameters parameters = widget.parameterProvider();
        Language.forLanguageCode(parameters.languageCode).then((language) {
          Game game = language.createGame(
            parameters.boardWidth,
            parameters.minimalWordLength,
          );

          GameInfo gameInfo = GameInfo(
            parameters: parameters,
            currentPlayer: 0,
            board: game.board,
            solution: game.solution,
            allUserAnswers: List.generate(
              parameters.numberOfPlayers,
              (_) => ValueNotifier(UserAnswer.start()),
            ),
          );

          Widget screenBuilder(BuildContext context) {
            return parameters.numberOfPlayers > 1
                ? PlayerScreen(
                    gameInfo: gameInfo,
                  )
                : GameScreen(
                    gameInfo: gameInfo,
                  );
          }

          if (widget.replaceScreen) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<Null>(
                builder: screenBuilder,
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute<Null>(
                builder: screenBuilder,
              ),
            ).then((value) {
              setState(() {
                isLoading = false;
              });
            });
          }
        });
      };
}
