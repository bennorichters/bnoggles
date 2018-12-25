// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/result/widgets/result_board.dart';
import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/widgets/board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helper.dart';

void main() {
  testWidgets('find board widget', (WidgetTester tester) async {
    Board board = createMockBoard();
    ValueNotifier<List<Coordinate>> highlightedTiles = ValueNotifier([]);

    await tester.pumpWidget(testableWidget(
      child: ResultBoard(
        board: board,
        highlightedTiles: highlightedTiles,
        cellWidth: 40,
      ),
    ));

    expect(find.byType(BoardWidget), findsOneWidget);
  });

  testWidgets('listens to changes in highlightedTiles',
      (WidgetTester tester) async {
    Board board = createMockBoard();
    ValueNotifier<List<Coordinate>> highlightedTiles = ValueNotifier([]);

    await tester.pumpWidget(testableWidget(
      child: ResultBoard(
        board: board,
        highlightedTiles: highlightedTiles,
        cellWidth: 40,
      ),
    ));

    expect(((find.text('A').evaluate().first.widget) as Text).style.color,
        Colors.black);

    highlightedTiles.value = [Coordinate(0, 0)];
    await tester.pumpAndSettle();
    expect(((find.text('A').evaluate().first.widget) as Text).style.color,
        Colors.white);
  });
}
