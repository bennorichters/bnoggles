// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/result/widgets/all_words_list.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helper.dart';

void main() {
  testWidgets('all words in solution are shown', (WidgetTester tester) async {
    Solution solution = createMockSolution(['abc', 'def'], 2);
    UserAnswer answer = UserAnswer.start();
    ValueNotifier<List<Coordinate>> highlightedTiles = ValueNotifier([]);

    await tester.pumpWidget(testableWidget(
      child: AllWordsList(
        solution: solution,
        userAnswer: answer,
        highlightedTiles: highlightedTiles,
      ),
    ));

    expect(find.text('ABC'), findsOneWidget);
    expect(find.text('DEF'), findsOneWidget);
  });

  testWidgets('found word by user is green, other is blue',
      (WidgetTester tester) async {
    Solution solution = createMockSolution(['abc', 'def'], 2);
    UserAnswer answer = UserAnswer.start().add('abc', true);
    ValueNotifier<List<Coordinate>> highlightedTiles = ValueNotifier([]);

    await tester.pumpWidget(testableWidget(
      child: AllWordsList(
        solution: solution,
        userAnswer: answer,
        highlightedTiles: highlightedTiles,
      ),
    ));

    Container containerAbc =
        tester.element(find.text("ABC")).ancestorWidgetOfExactType(Container);
    BoxDecoration decorationAbc = containerAbc.decoration;
    expect(decorationAbc.color, Colors.green);

    Container containerDef =
        tester.element(find.text("DEF")).ancestorWidgetOfExactType(Container);
    BoxDecoration decorationDef = containerDef.decoration;
    expect(decorationDef.color, Colors.lightBlueAccent);
  });

  testWidgets('tapping words selects coordinates', (WidgetTester tester) async {
    Solution solution = createMockSolution(['abc', 'def'], 2);
    UserAnswer answer = UserAnswer.start();
    ValueNotifier<List<Coordinate>> highlightedTiles = ValueNotifier([]);

    await tester.pumpWidget(testableWidget(
      child: AllWordsList(
        solution: solution,
        userAnswer: answer,
        highlightedTiles: highlightedTiles,
      ),
    ));

    expect(highlightedTiles.value.isEmpty, true);

    await tester.tap(find.text('ABC'));
    await tester.pumpAndSettle();

    expect(highlightedTiles.value, [
      Coordinate(0, 0),
      Coordinate(0, 1),
      Coordinate(0, 2),
    ]);
  });
}
