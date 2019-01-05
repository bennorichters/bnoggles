// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A list of all words present in the [solution]
///
/// Words that are also present in [userAnswer] are shown in a different colors
/// than those that are not.
///
/// Tapping a word replaces the value of [highlightedTiles] with the coordinates
/// that are associated with one of the [Chain]s for that word in the solution.
class ResultAllWordsList extends StatelessWidget {
  /// Creates an instance of [ResultAllWordsList].
  ResultAllWordsList({
    @required this.solution,
    @required this.userAnswers,
    @required this.highlightedTiles,
  });

  final Solution solution;
  final List<UserAnswer> userAnswers;
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
                  margin: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: foundByEveryone(word)
                        ? Colors.green
                        : foundBySome(word)
                            ? Colors.lightGreenAccent
                            : Colors.lightBlueAccent,
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Text(
                    wordText(word),
                    style: TextStyle(
                      fontSize: 10.0,
                      color:
                          foundByEveryone(word) ? Colors.white : Colors.black,
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

  String wordText(String word) {
    StringBuffer result = StringBuffer(word.toUpperCase());
    if (userAnswers.length > 1) {
      result.write('\n');

      for (int i = 0; i < userAnswers.length; i++) {
        result.write(userAnswers[i].contains(word) ? (i + 1).toString() : '_');

        if (i < userAnswers.length - 1) {
          result.write(' ');
        }
      }
    }

    return result.toString();
  }

  bool foundByEveryone(String word) =>
      !userAnswers.any((a) => !a.contains(word));

  bool foundBySome(String word) => userAnswers.any((a) => a.contains(word));
}
