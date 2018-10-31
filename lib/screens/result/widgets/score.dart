import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScoreOverview extends StatelessWidget {
  final ScoreSheet scores;
  final double fontSize;

  ScoreOverview({Key key, @required this.scores, @required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            buildText('${scores.score}', Colors.purple),
          ]),
          TableRow(children: [
            Icon(
              Icons.done,
              size: 40.0,
              color: Colors.green,
            ),
            buildText('${scores.foundWords}', Colors.green),
          ]),
          TableRow(children: [
            Icon(Icons.done_all, size: 40.0, color: Colors.blue),
            buildText('${scores.availableWords}', Colors.blue),
          ]),
        ],
      ),
    );
  }

  Text buildText(String text, Color color) =>
      Text(text, style: TextStyle(fontSize: fontSize, color: color));
}
