import 'package:bnoggles/screens/game/widgets/game_clock.dart';
import 'package:bnoggles/screens/game/widgets/game_word_count_row.dart';
import 'package:bnoggles/screens/result/result_screen.dart';
import 'package:bnoggles/utils/solution.dart';
import 'package:bnoggles/widgets/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GameProgress extends StatelessWidget {
  @override
  build(BuildContext context) {
    var showResultScreen = () {
            Solution solution = Provider.immutableDataOf(context)["solution"];
            UserAnswer userAnswer = Provider.mutableDataOf(context).value;

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ResultScreen(solution, userAnswer)));
          };
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 300.0, height: 127.0, child: WordCountOverview()),
          Clock(showResultScreen),
          IconButton(icon: Icon(Icons.close), onPressed: showResultScreen,)
        ]);
  }
}
