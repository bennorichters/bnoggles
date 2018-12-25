// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/widgets/board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../widget_test_helper.dart';

void main() {
  testWidgets('find all letters', (WidgetTester tester) async {
    Board board = createMockBoard();

    await tester.pumpWidget(testableWidget(
      child: BoardWidget(
        board: board,
        selectedPositions: [],
        cellWidth: 40,
      ),
    ));

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
    expect(find.text('E'), findsOneWidget);
    expect(find.text('F'), findsOneWidget);
    expect(find.text('G'), findsOneWidget);
    expect(find.text('H'), findsOneWidget);
    expect(find.text('I'), findsOneWidget);
  });

  testWidgets('selected positions have different color',
      (WidgetTester tester) async {
    Board board = createMockBoard();

    await tester.pumpWidget(testableWidget(
      child: BoardWidget(
        board: board,
        selectedPositions: [Coordinate(0, 1)],
        cellWidth: 40,
      ),
    ));

    expect(((find.text('A').evaluate().first.widget) as Text).style.color,
        Colors.black);

    expect(((find.text('B').evaluate().first.widget) as Text).style.color,
        Colors.white);
  });

  testWidgets('empty cell provider does not have text',
      (WidgetTester tester) async {
    Board board = createMockBoard();

    Widget justAContainer({
      double cellWidth,
      String character,
      bool selected,
      Coordinate position,
    }) =>
        Container();

    await tester.pumpWidget(testableWidget(
      child: BoardWidget(
        board: board,
        selectedPositions: [],
        cellWidth: 40,
        centeredCharacter: justAContainer,
      ),
    ));

    expect(find.text('A'), findsNothing);
  });

  testWidgets('defaultCellProvider creates text', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(
      child: defaultCellProvider(
        character: 'a',
        cellWidth: 40,
        selected: false,
      ),
    ));

    expect(find.text('A'), findsOneWidget);
  });
}
