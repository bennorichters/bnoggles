// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_board.dart';
import 'package:bnoggles/screens/game/widgets/game_clock.dart';
import 'package:bnoggles/screens/game/widgets/game_progress.dart';
import 'package:bnoggles/screens/game/widgets/game_word_list_window.dart';
import 'package:bnoggles/screens/game/widgets/game_info_provider.dart';
import 'package:bnoggles/screens/player/player_screen.dart';
import 'package:bnoggles/screens/result/result_screen.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter/material.dart';

/// The screen on which the game is played.
class GameScreen extends StatefulWidget {
  /// Creates an instance of [GameScreen].
  GameScreen({
    Key key,
    @required this.gameInfo,
  }) : super(key: key);

  final GameInfo gameInfo;

  @override
  State createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  AnimationController controller;
  bool controllerDisposed = false;

  @override
  void initState() {
    super.initState();

    if (widget.gameInfo.parameters.hasTimeLimit) {
      controller = AnimationController(
        vsync: this,
        duration: Duration(
          seconds: widget.gameInfo.parameters.time,
        ),
      );

      controller.forward(from: 0.0);
    }

    widget.gameInfo.userAnswer.addListener(checkDone);
  }

  void checkDone() {
    if ((widget.gameInfo.solution.frequency -
            widget.gameInfo.userAnswer.value.frequency)
        .isEmpty) {
      nextScreen();
    }
  }

  void nextScreen() {
    disposeController();

    var gameInfo = widget.gameInfo;

    bool finished = false;
    if (gameInfo.currentPlayer == gameInfo.parameters.numberOfPlayers - 1) {
      finished = true;
    } else {
      gameInfo.currentPlayer++;
    }

    Navigator.pushReplacement(
        context,
        MaterialPageRoute<Null>(
          builder: (finished)
              ? (context) => ResultScreen(gameInfo: gameInfo)
              : (context) => PlayerScreen(gameInfo: gameInfo),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget timeWidget = widget.gameInfo.parameters.hasTimeLimit
        ? Clock(
            timeOutAction: nextScreen,
            controller: controller,
            startTime: widget.gameInfo.parameters.time,
          )
        : Container(
            color: Colors.lightBlueAccent,
            child: Center(
              child: const Text('–:––'),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bnoggles"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.stop),
            color: Colors.red,
            onPressed: () {
              nextScreen();
            },
          ),
        ],
      ),
      body: GameInfoProvider(
        gameInfo: widget.gameInfo,
        child: Column(
          children: [
            GameProgress(
              timeWidget: timeWidget,
            ),
            Expanded(
              child: const WordListWindow(),
            ),
            const GameBoard(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.gameInfo.userAnswer.removeListener(checkDone);
    disposeController();
    super.dispose();
  }

  void disposeController() {
    if (widget.gameInfo.parameters.hasTimeLimit && !controllerDisposed) {
      controller.dispose();
      controllerDisposed = true;
    }
  }
}
