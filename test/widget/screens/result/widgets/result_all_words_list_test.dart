// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/result/widgets/result_all_words_list.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/answer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_helper.dart';
import '../../../widget_test_helper.dart';

void main() {
  testWidgets('all words in solution are shown', (WidgetTester tester) async {
    Solution solution = createMockSolution(['abc', 'def'], 2);
    UserAnswer answer = UserAnswer.start();

    await tester.pumpWidget(testableWidget(
      child: ResultAllWordsList(
        solution: solution,
        userAnswers: [answer],
        highlightedTiles: ValueNotifier([]),
      ),
    ));

    expect(find.text('ABC'), findsOneWidget);
    expect(find.text('DEF'), findsOneWidget);
  });

  testWidgets('found word by user is green, other is blue',
      (WidgetTester tester) async {
    Solution solution = createMockSolution(['abc', 'def'], 2);
    UserAnswer answer = UserAnswer.start().add('abc', true);

    await tester.pumpWidget(testableWidget(
      child: ResultAllWordsList(
        solution: solution,
        userAnswers: [answer],
        highlightedTiles: ValueNotifier([]),
      ),
    ));

    testColor(tester, find.text("ABC"), Colors.green);
    testColor(tester, find.text("DEF"), Colors.lightBlueAccent);
  });

  testWidgets('show words with info of who found those words with right color',
      (WidgetTester tester) async {
    Solution solution = createMockSolution(['abc', 'def', 'ghi'], 2);
    UserAnswer answer1 = UserAnswer.start().add('abc', true);
    UserAnswer answer2 = UserAnswer.start().add('abc', true).add('def', true);

    await tester.pumpWidget(testableWidget(
      child: ResultAllWordsList(
        solution: solution,
        userAnswers: [answer1, answer2],
        highlightedTiles: ValueNotifier([]),
      ),
    ));

    var abc = find.text('ABC\n1 2');
    expect(abc, findsOneWidget);
    testColor(tester, abc, Colors.green);

    var def = find.text('DEF\n_ 2');
    expect(def, findsOneWidget);
    testColor(tester, def, Colors.lightGreenAccent);

    var ghi = find.text('GHI\n_ _');
    expect(ghi, findsOneWidget);
    testColor(tester, ghi, Colors.lightBlueAccent);
  });

  testWidgets('tapping words selects coordinates', (WidgetTester tester) async {
    Solution solution = createMockSolution(['abc', 'def'], 2);
    UserAnswer answer = UserAnswer.start();
    ValueNotifier<List<Coordinate>> highlightedTiles = ValueNotifier([]);

    await tester.pumpWidget(testableWidget(
      child: ResultAllWordsList(
        solution: solution,
        userAnswers: [answer],
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

void testColor(WidgetTester tester, Finder finder, Color color) {
  Container container =
      tester.element(finder).ancestorWidgetOfExactType(Container);
  BoxDecoration decoration = container.decoration;
  expect(decoration.color, color);
}
