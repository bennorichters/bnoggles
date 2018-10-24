import 'package:bnoggles/screens/game/widgets/game_board_grid.dart';
import 'package:bnoggles/screens/game/widgets/game_progress.dart';
import 'package:bnoggles/screens/game/widgets/game_word_window.dart';
import 'package:bnoggles/screens/game/widgets/provider.dart';
import 'package:bnoggles/screens/result/result_screen.dart';
import 'package:bnoggles/utils/board.dart';
import 'package:bnoggles/utils/solution.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final Board board;
  final Solution solution;
  final int startValue;

  GameScreen(
      {Key key,
      @required this.board,
      @required this.solution,
      @required this.startValue})
      : super(key: key);

  @override
  State createState() =>
      GameScreenState(board: board, solution: solution, startValue: startValue);
}

class GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final GameInfo gameInfo;
  final int _startValue;

  AnimationController _controller;
  bool controllerDisposed = false;

  GameScreenState({@required board, solution, startValue})
      : gameInfo = GameInfo(
            board: board,
            solution: solution,
            userAnswer: ValueNotifier(UserAnswer.start())),
        _startValue = startValue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _startValue),
    );

    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    showResultScreen() {
      UserAnswer userAnswer = gameInfo.userAnswer.value;
      gameInfo.gameOngoing = false;

      disposeController();

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ResultScreen(gameInfo.solution, userAnswer)));
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
                GameProgress(_controller, _startValue, showResultScreen),
                Expanded(child: Center(child: WordWindow())),
                Grid(gameInfo.board.mapNeighbours()),
              ],
            )));
  }

  @override
  dispose() {
    disposeController();
    super.dispose();
  }

  disposeController() {
    if (!controllerDisposed) {
      _controller.dispose();
      controllerDisposed = true;
    }
  }
}
