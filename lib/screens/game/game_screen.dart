import 'package:bnoggles/screens/game/widgets/game_board_grid.dart';
import 'package:bnoggles/screens/game/widgets/game_progress.dart';
import 'package:bnoggles/screens/game/widgets/game_word_window.dart';
import 'package:bnoggles/screens/game/widgets/provider.dart';
import 'package:bnoggles/screens/result/result_screen.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final GameInfo gameInfo;

  GameScreen({
    Key key,
    @required this.gameInfo,
  }) : super(key: key);

  @override
  State createState() => GameScreenState(gameInfo: gameInfo);
}

class GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final GameInfo gameInfo;

  AnimationController _controller;
  bool controllerDisposed = false;

  GameScreenState({@required this.gameInfo});

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          Duration(seconds: gameInfo.configuration.preferences.time.value),
    );

    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    void showResultScreen() {
      UserAnswer userAnswer = gameInfo.userAnswer.value;
      gameInfo.gameOngoing = false;

      disposeController();

      Navigator.pushReplacement(
          context,
          MaterialPageRoute<Null>(
              builder: (context) =>
                  ResultScreen(gameInfo.board, gameInfo.solution, userAnswer)));
    }

    return Scaffold(
        appBar:
            AppBar(title: Text("Bnoggles"), leading: new Container(), actions: [
          IconButton(
            icon: Icon(Icons.stop),
            color: Colors.red,
            onPressed: () {
              showResultScreen();
            },
          ),
        ]),
        body: Provider(
            gameInfo: gameInfo,
            child: Column(
              children: [
                GameProgress(
                    _controller,
                    gameInfo.configuration.preferences.time.value,
                    showResultScreen),
                Expanded(child: Center(child: WordWindow())),
                Grid(gameInfo.board.mapNeighbours()),
              ],
            )));
  }

  @override
  void dispose() {
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
