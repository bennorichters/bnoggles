// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_board_grid.dart';
import 'package:bnoggles/screens/game/widgets/game_progress.dart';
import 'package:bnoggles/screens/game/widgets/game_word_window.dart';
import 'package:bnoggles/screens/game/widgets/provider.dart';
import 'package:bnoggles/screens/result/result_screen.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  GameScreen({
    Key key,
    @required this.gameInfo,
  }) : super(key: key);

  final GameInfo gameInfo;

  @override
  State createState() => _GameScreenState(gameInfo: gameInfo);
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  _GameScreenState({@required this.gameInfo});

  final GameInfo gameInfo;

  AnimationController _controller;
  bool controllerDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: gameInfo.parameters.time),
    );

    _controller.forward(from: 0.0);

    gameInfo.userAnswer.addListener(checkDone);
  }

  void checkDone() {
    if ((gameInfo.solution.frequency - gameInfo.userAnswer.value.frequency)
        .isEmpty) {
      showResultScreen();
    }
  }

  void showResultScreen() {
    disposeController();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Null>(
        builder: (context) => ResultScreen(gameInfo: gameInfo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Bnoggles"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.stop),
              color: Colors.red,
              onPressed: () {
                showResultScreen();
              },
            ),
          ],
        ),
        body: Provider(
          gameInfo: gameInfo,
          child: Column(
            children: [
              GameProgress(
                _controller,
                gameInfo.parameters.time,
                showResultScreen,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: wordLines(gameInfo.parameters.hints),
                ),
              ),
              const Grid(),
            ],
          ),
        ),
      );

  List<Widget> wordLines(bool hints) {
    WordsProvider byUser = () => gameInfo.userAnswer.value.found.reversed
        .map((a) => Word.fromUser(a))
        .toList();

    if (!hints) {
      return [WordWindow(byUser, gameInfo.userAnswer)];
    }

    WordsProvider byGame = () => gameInfo.randomWords
        .where((w) =>
            !gameInfo.userAnswer.value.found.map((w) => w.word).contains(w))
        .map((a) => Word.neutral(a))
        .toList();

    return [
      WordWindow(byUser, gameInfo.userAnswer),
      WordWindow(byGame, gameInfo.userAnswer),
    ];
  }

  @override
  void dispose() {
    gameInfo.userAnswer.removeListener(checkDone);
    disposeController();
    super.dispose();
  }

  void disposeController() {
    if (!controllerDisposed) {
      _controller.dispose();
      controllerDisposed = true;
    }
  }
}
