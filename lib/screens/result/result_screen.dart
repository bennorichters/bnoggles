import 'package:bnoggles/utils/board.dart';
import 'package:bnoggles/widgets/board_widget.dart';
import 'package:flutter/material.dart';

import 'package:bnoggles/utils/solution.dart';

class ResultScreen extends StatelessWidget {
  final Board board;
  final Solution solution;
  final UserAnswer userAnswer;

  ResultScreen(this.board, this.solution, this.userAnswer);

  @override
  Widget build(BuildContext context) {
    int score = calculateScore(solution, userAnswer);
    int maxScore = calculateScore(solution, solution);

    var tiles = solution.uniqueWordsSorted().map((w) {
      return ListTile(
          dense: true,
          contentPadding: EdgeInsets.all(5.0),
          title: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: userAnswer.contains(w)
                      ? Colors.green
                      : Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Text(w.toUpperCase(),
                  style: TextStyle(
                      color: userAnswer.contains(w)
                          ? Colors.white
                          : Colors.black))));
    });

    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Bnoggles"),
      ),
      body: Center(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              width: 150.0,
              child: ListView(children: divided)),
          Expanded(
            child: Column(children: [
              Center(
                  child: Container(
                      child: Text(
                "$score / $maxScore",
                style: TextStyle(fontSize: 100.0),
              ))),
              Container(
                  margin: const EdgeInsets.all(10.0),
                  child: BoardWidget(
                    selectedPositions: [],
                    board: board,
                    centeredCharacter: CenteredCharacter(20.0),
                  )),
              FloatingActionButton(
                onPressed: () {
                  Navigator.popUntil(
                      context, ModalRoute.withName(Navigator.defaultRouteName));
                },
                child: Icon(Icons.home),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  int calculateScore(Solution solution, Answer userAnswer) {
    int result = 0;
    for (String word in userAnswer.uniqueWords()) {
      result += word.length * 2;
    }

    var percentageFound =
        (userAnswer.uniqueWords().length / solution.uniqueWords().length);

    result = (result * percentageFound * percentageFound).round();

    result += userAnswer.uniqueWords().length;

    return result;
  }
}
