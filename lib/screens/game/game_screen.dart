// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:bnoggles/screens/game/widgets/game_board.dart';
import 'package:bnoggles/screens/game/widgets/game_clock.dart';
import 'package:bnoggles/screens/game/widgets/game_progress.dart';
import 'package:bnoggles/screens/game/widgets/game_word_list_window.dart';
import 'package:bnoggles/screens/game/widgets/game_info_provider.dart';
import 'package:bnoggles/screens/player/player_screen.dart';
import 'package:bnoggles/screens/result/result_screen.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/widget_logic/widget_logic.dart';
import 'package:flutter/material.dart';

final _blockHeightCalculator = Interpolator.fromDataPoints(
  p1: const Point(592, 25),
  p2: const Point(683.4, 40),
  min: 25,
  max: 40,
);

final _fontSizeCalculator = Interpolator.fromDataPoints(
  p1: const Point(592, 10),
  p2: const Point(683.4, 14),
  min: 8,
  max: 14,
);

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

    GameInfo gameInfo = widget.gameInfo;

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
    MediaQueryData data = MediaQuery.of(context);
    double screenHeight = data.size.height;
    double blockHeight = _blockHeightCalculator.y(x: screenHeight);
    double wordCountFontSize = _fontSizeCalculator.y(x: screenHeight);

    print('GameScreen.build: ${data.size}, ${blockHeight * .7}');
    // 384.0, 592.0 -> 17.5
    // 411.4, 683.4 -> 28

    Widget timeWidget = widget.gameInfo.parameters.hasTimeLimit
        ? Clock(
            timeOutAction: nextScreen,
            controller: controller,
            startTime: widget.gameInfo.parameters.time,
            fontSize: blockHeight * .7,
          )
        : Container(
            color: Colors.lightBlueAccent,
            child: Center(
              child: Text('–:––',
                  style: TextStyle(
                    fontFamily: 'Inconsolata',
                    fontSize: blockHeight * .7,
                  )),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bnoggles'),
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
              blockHeight: blockHeight,
              wordCountFontSize: wordCountFontSize,
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
