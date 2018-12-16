// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_board_grid.dart';
import 'package:bnoggles/screens/game/widgets/provider.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/lettter_sequence.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../widget_test_helper.dart';

class MockParameters extends Mock implements GameParameters {}

class MockBoard extends Mock implements Board {}

class MockSolution extends Mock implements Solution {}

class MockRandomLetterGenerator extends Mock implements SequenceGenerator {}

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('All letters present', (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(600, 800));
    GameInfo info = createGameInfo();
    await tester.pumpWidget(testableGrid(info));

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

  testWidgets('Find word', (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(600, 800));
    GameInfo info = createGameInfo();
    await tester.pumpWidget(testableGrid(info));

    expect(info.userAnswer.value.contains('abc'), false);

    var offsetStart = tester.getCenter(find.text('A'));
    var offSetMiddle = tester.getCenter(find.text('B'));
    var offsetEnd = tester.getCenter(find.text('C'));
    var vector1 = offSetMiddle - offsetStart;
    var vector2 = offsetEnd - offSetMiddle;

    TestGesture gesture = await tester.startGesture(offsetStart);
    await gesture.moveBy(vector1);
    await gesture.moveBy(vector2);
    await gesture.up();

    await tester.pumpAndSettle();

    expect(info.userAnswer.value.contains('abc'), true);
  });

  testWidgets('Do not find word', (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(600, 800));
    GameInfo info = createGameInfo();
    await tester.pumpWidget(testableGrid(info));

    expect(info.userAnswer.value.contains('abc'), false);

    var offsetStart = tester.getCenter(find.text('A'));
    var offSetMiddle = tester.getCenter(find.text('D'));
    var offsetEnd = tester.getCenter(find.text('G'));
    var vector1 = offSetMiddle - offsetStart;
    var vector2 = offsetEnd - offSetMiddle;

    TestGesture gesture = await tester.startGesture(offsetStart);
    await gesture.moveBy(vector1);
    await gesture.moveBy(vector2);
    await gesture.up();

    await tester.pumpAndSettle();

    expect(info.userAnswer.value.contains('abc'), false);
    expect(info.userAnswer.value.contains('adg'), false);
  });
}

Widget testableGrid(GameInfo info) {
  Grid grid = Grid(info.board.mapNeighbours());

  Provider provider = Provider(
    gameInfo: info,
    child: Container(width: 500.0, height: 500.0, child: grid),
  );

  return testableWidgetWithMediaQuery(provider, 600.0, 800.0);
}

GameInfo createGameInfo() {
  var mockParameters = MockParameters();
  var mockBoard = createMockBoard();
  var mockSolution = MockSolution();
  var vua = ValueNotifier(UserAnswer.start());

  when(mockSolution.uniqueWords()).thenReturn(['abc'].toSet());
  when(mockSolution.minimalLength).thenReturn(2);
  when(mockSolution.isCorrect("abc")).thenReturn(true);
  when(mockSolution.isCorrect(argThat(isNot("abc")))).thenReturn(false);

  GameInfo info = GameInfo(
    parameters: mockParameters,
    board: mockBoard,
    solution: mockSolution,
    userAnswer: vua,
  );
  return info;
}

Board createMockBoard() {
  var allCoordinates = [
    Coordinate(0, 0),
    Coordinate(0, 1),
    Coordinate(0, 2),
    Coordinate(1, 0),
    Coordinate(1, 1),
    Coordinate(1, 2),
    Coordinate(2, 0),
    Coordinate(2, 1),
    Coordinate(2, 2),
  ];

  var rlg = MockRandomLetterGenerator();
  when(rlg.next()).thenAnswer((s) => 'a');
  Board realBoard = Board(
    width: 3,
    generator: rlg,
  );

  var mockBoard = MockBoard();
  when(mockBoard[allCoordinates[0]]).thenReturn('a');
  when(mockBoard[allCoordinates[1]]).thenReturn('b');
  when(mockBoard[allCoordinates[2]]).thenReturn('c');
  when(mockBoard[allCoordinates[3]]).thenReturn('d');
  when(mockBoard[allCoordinates[4]]).thenReturn('e');
  when(mockBoard[allCoordinates[5]]).thenReturn('f');
  when(mockBoard[allCoordinates[6]]).thenReturn('g');
  when(mockBoard[allCoordinates[7]]).thenReturn('h');
  when(mockBoard[allCoordinates[8]]).thenReturn('i');

  when(mockBoard.width).thenReturn(3);

  when(mockBoard.allCoordinates()).thenReturn(allCoordinates);

  when(mockBoard.mapNeighbours()).thenReturn(realBoard.mapNeighbours());

  return mockBoard;
}
