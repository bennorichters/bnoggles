import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/widgets/board_widget.dart';
import 'package:flutter/material.dart';

import 'package:bnoggles/utils/gamelogic/solution.dart';

class ResultScreen extends StatefulWidget {
  final GameInfo gameInfo;
  ResultScreen({@required this.gameInfo});

  @override
  State<StatefulWidget> createState() => ResultScreenState(gameInfo: gameInfo);
}

class ResultScreenState extends State<ResultScreen> {
  final GameInfo gameInfo;
  List<Coordinate> highlightedTiles = [];

  ResultScreenState({@required this.gameInfo});

  @override
  Widget build(BuildContext context) {
    Solution solution = gameInfo.solution;
    UserAnswer userAnswer = gameInfo.userAnswer.value;
    Board board = gameInfo.board;

    int score = calculateScore(solution, userAnswer);
    int maxScore = calculateScore(solution, solution);

    double wordViewWidth = 150.0;
    double mediaWidth = MediaQuery.of(context).size.width;
    double secondColumnWidth = (mediaWidth - wordViewWidth);
    double cellWidth = secondColumnWidth / board.width;

    Map<String, List<Coordinate>> optionPerWord = Map.fromIterable(
        solution.chains,
        key: (dynamic chain) => (chain as Chain).text,
        value: (dynamic chain) => (chain as Chain).chain);

    void doSomething(String word) {
      setState(() {
        highlightedTiles = optionPerWord[word];
      });
    }

    var tiles = solution.uniqueWordsSorted().map((word) => ListTile(
          dense: true,
          contentPadding: EdgeInsets.all(5.0),
          title: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: userAnswer.contains(word)
                      ? Colors.green
                      : Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Text(word.toUpperCase(),
                  style: TextStyle(
                      color: userAnswer.contains(word)
                          ? Colors.white
                          : Colors.black))),
          onTap: () {
            doSomething(word);
          },
        ));

    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Bnoggles"),
        leading: new Container(),
      ),
      body: Center(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              width: wordViewWidth,
              child: ListView(children: divided)),
          Expanded(
            child: Column(children: [
              Center(
                  child: Container(
                      child: Text(
                "$score / $maxScore",
                style: TextStyle(fontSize: secondColumnWidth / 8),
              ))),
              Container(
                  margin: const EdgeInsets.all(10.0),
                  child: BoardWidget(
                    selectedPositions: highlightedTiles,
                    board: board,
                    centeredCharacter: CenteredCharacter(cellWidth),
                  )),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.popUntil(context,
                        ModalRoute.withName(Navigator.defaultRouteName));
                  },
                  child: Icon(Icons.home),
                ),
                Container(
                  width: 20.0,
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.popUntil(context,
                        ModalRoute.withName(Navigator.defaultRouteName));
                  },
                  child: Icon(Icons.forward),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  int calculateScore(Solution solution, Answer userAnswer) {
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
