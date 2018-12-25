// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AllWordsList extends StatelessWidget {
  AllWordsList({
    @required this.solution,
    @required this.userAnswer,
    @required this.highlightedTiles,
  });

  final Solution solution;
  final UserAnswer userAnswer;
  final ValueNotifier<List<Coordinate>> highlightedTiles;

  @override
  Widget build(BuildContext context) {
    Map<String, List<Coordinate>> optionPerWord = Map.fromIterable(
        solution.chains,
        key: (dynamic chain) => (chain as Chain).text,
        value: (dynamic chain) => (chain as Chain).chain);

    List<Widget> tiles = solution
        .uniqueWordsSorted()
        .map(
          (word) => GestureDetector(
                child: Container(
                  margin: EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: userAnswer.contains(word)
                        ? Colors.green
                        : Colors.lightBlueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Text(
                    word.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.0,
                      color: userAnswer.contains(word)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                onTap: () {
                  highlightedTiles.value = optionPerWord[word];
                },
              ),
        )
        .toList();

    return ListView(children: tiles);
  }
}
