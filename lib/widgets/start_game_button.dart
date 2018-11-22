// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:bnoggles/utils/language.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/material.dart';

class StartGameButton extends StatefulWidget {
  StartGameButton(
      {Key key, @required this.parameterProvider, @required this.replaceScreen})
      : super(key: key);

  final ParameterProvider parameterProvider;
  final bool replaceScreen;

  @override
  State<StatefulWidget> createState() => _StartGameButtonState();
}

class _StartGameButtonState extends State<StartGameButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) => isLoading
      ? CircularProgressIndicator()
      : FloatingActionButton(
          heroTag: "playgame",
          onPressed: _pressPlayButton(context),
          child: Icon(Icons.play_arrow),
        );

  VoidCallback _pressPlayButton(BuildContext context) => () {
        setState(() {
          isLoading = true;
        });

        var parameters = widget.parameterProvider();
        Language.forLanguageCode(parameters.languageCode).then((language) {
          var game = language.createGame(
            parameters.boardWidth,
            parameters.minimalWordLength,
          );

          GameInfo gameInfo = GameInfo(
            parameters: parameters,
            board: game.board,
            solution: game.solution,
            userAnswer: ValueNotifier(UserAnswer.start()),
          );

          if (widget.replaceScreen) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<Null>(
                builder: (context) => GameScreen(
                      gameInfo: gameInfo,
                    ),
              ),
            ).then((value) {
              setState(() {
                isLoading = false;
              });
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute<Null>(
                builder: (context) => GameScreen(
                      gameInfo: gameInfo,
                    ),
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
