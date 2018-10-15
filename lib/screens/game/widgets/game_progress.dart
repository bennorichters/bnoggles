import 'package:bnoggles/screens/game/widgets/game_clock.dart';
import 'package:bnoggles/screens/game/widgets/game_word_count_row.dart';
import 'package:bnoggles/screens/result/result_screen.dart';
import 'package:bnoggles/utils/solution.dart';
import 'package:bnoggles/screens/game/widgets/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GameProgress extends StatefulWidget {
  State createState() => _GameProgressState();
}

class _GameProgressState extends State<GameProgress>
    with TickerProviderStateMixin {
  AnimationController _controller;

  static const int _startValue = 150;

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
  build(BuildContext context) {
    var showResultScreen = () {
      Solution solution = Provider.immutableDataOf(context)["solution"];
      UserAnswer userAnswer = Provider.mutableDataOf(context).value;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultScreen(solution, userAnswer)));
    };

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 300.0, height: 127.0, child: WordCountOverview()),
          Clock(showResultScreen, _controller, _startValue),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              _controller.stop();
              showResultScreen();
            },
          )
        ]);
  }
}
