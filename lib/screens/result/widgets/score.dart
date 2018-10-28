import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScoreOverview extends StatelessWidget {
  final Solution solution;
  final Answer userAnswer;
  final double fontSize;

  ScoreOverview(
      {Key key,
      @required this.solution,
      @required this.userAnswer,
      @required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int score = _calculateScore();
    int foundWords = userAnswer.uniqueWords().length;
    int totalWords = solution.uniqueWords().length;

    return Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.all(25.0),
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(50.0),
          1: FixedColumnWidth(50.0),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Icon(
              Icons.tag_faces,
              size: 40.0,
              color: Colors.purple,
            ),
            buildText("$score", Colors.purple),
          ]),
          TableRow(children: [
            Icon(
              Icons.done,
              size: 40.0,
              color: Colors.green,
            ),
            buildText("$foundWords", Colors.green),
          ]),
          TableRow(
            children: [
              Icon(Icons.done_all, size: 40.0, color: Colors.blue),
              buildText("$totalWords", Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Text buildText(String text, Color color) =>
      Text(text, style: TextStyle(fontSize: fontSize, color: color));

  int _calculateScore() {
    var goodAnswerCount = solution.uniqueWords().length;
    if (goodAnswerCount == 0) {
      return 0;
    }

    int result = 0;
    for (String word in userAnswer.uniqueWords()) {
      result += word.length * 2;
    }

    var percentageFound = (userAnswer.uniqueWords().length / goodAnswerCount);
    result = (result * percentageFound * percentageFound).round();
    result += userAnswer.uniqueWords().length;

    return result;
  }
}
