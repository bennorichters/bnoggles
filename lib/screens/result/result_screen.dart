import 'package:flutter/material.dart';

import 'package:bnoggles/utils/solution.dart';

class ResultScreen extends StatelessWidget {
  final Solution solution;
  final UserAnswer userAnswer;

  ResultScreen(this.solution, this.userAnswer);

  @override
  Widget build(BuildContext context) {
    int score = calculateScore(solution, userAnswer);

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
          Expanded(child: Container()),
          Center(
              child: Container(
                  child: Text(
            "$score",
            style: TextStyle(fontSize: 100.0),
          ))),
          Expanded(child: Container()),
        ]),
      ),
    );
  }

  int calculateScore(Solution solution, UserAnswer userAnswer) {
    int result = 0;
    for (String word in solution.uniqueWordsSorted()) {
      if (userAnswer.contains(word)) {
        result += 1 + word.length * 2;
      }
    }

    print(result);

    return (result *
            (userAnswer.uniqueWords().length / solution.uniqueWords().length))
        .floor();
  }
}
