import 'package:flutter/material.dart';

import 'package:bnoggles/utils/solution.dart';

class ResultScreen extends StatelessWidget {
  final Solution solution;
  final UserAnswer userAnswer;

  ResultScreen(this.solution, this.userAnswer);

  @override
  Widget build(BuildContext context) {
    var tiles = solution.uniqueWordsSorted().map((w) {
      return ListTile(
          title: new Text(w.toUpperCase(),
              style: TextStyle(
                  color:
                      userAnswer.contains(w) ? Colors.green : Colors.black)));
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
        child: new ListView(children: divided),
      ),
    );
  }
}
