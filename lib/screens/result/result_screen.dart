import 'package:bnoggles/screens/result/widgets/score.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/widgets/board_widget.dart';
import 'package:bnoggles/widgets/start_game_button.dart';
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

    double mediaWidth = MediaQuery.of(context).size.width;
    double wordViewWidth = mediaWidth / 6;
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

    List<Widget> tiles = solution.uniqueWordsSorted().map((word) => GestureDetector(
          child: Container(
              margin: EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: userAnswer.contains(word)
                      ? Colors.green
                      : Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Text(word.toUpperCase(),
                  style: TextStyle(
                      fontSize: 10.0,
                      color: userAnswer.contains(word)
                          ? Colors.white
                          : Colors.black))),
          onTap: () {
            doSomething(word);
          },
        )).toList();

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
              child: ListView(children: tiles)),
          Expanded(
            child: Column(
              children: [
                Expanded(
                    child: Center(
                        child: ScoreOverview(
                  solution: solution,
                  userAnswer: userAnswer,
                  fontSize: secondColumnWidth / 25,
                ))),
                Container(
                    margin: const EdgeInsets.all(10.0),
                    child: BoardWidget(
                      selectedPositions: highlightedTiles,
                      board: board,
                      centeredCharacter: CenteredCharacter(cellWidth),
                    )),
                Container(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            heroTag: "home",
                            onPressed: () {
                              Navigator.popUntil(
                                  context,
                                  ModalRoute.withName(
                                      Navigator.defaultRouteName));
                            },
                            child: Icon(Icons.home),
                          ),
                          Container(
                            width: 20.0,
                          ),
                          StartGameButton(
                              configuration: gameInfo.configuration),
                        ]))
              ],
            ),
          )
        ]),
      ),
    );
  }
}
