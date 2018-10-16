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

  GameScreen({Key key, @required this.board, @required this.solution})
      : super(key: key);

  @override
  State createState() => GameScreenState(board: board, solution: solution);
}

class GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final Board board;
  final Solution solution;
  AnimationController _controller;
  static const int _startValue = 150;

  GameScreenState({@required this.board, @required this.solution});

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

    var gameInfo = GameInfo(
        board: board,
        solution: solution,
        userAnswer: ValueNotifier(UserAnswer.start()));

    showResultScreen() {
      UserAnswer userAnswer = gameInfo.userAnswer.value;
      gameInfo.gameOngoing = false;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultScreen(solution, userAnswer)));
    };

    return Scaffold(
        appBar: AppBar(
          title: Text("Bnoggles"),
        ),
        body: Provider(
            gameInfo: gameInfo,
            child: Column(
              children: [
                GameProgress(_controller, _startValue, showResultScreen),
                Expanded(child: WordWindow()),
                Grid(board.mapNeighbours()),
              ],
            )));
  }
}

