// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/provider.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../widget_test_helper.dart';

class MockParameters extends Mock implements GameParameters {}

class MockBoard extends Mock implements Board {}

class MockSolution extends Mock implements Solution {}

void main() {
  testWidgets('child of provider responds ot change',
      (WidgetTester tester) async {
    var mockParameters = MockParameters();
    var mockBoard = MockBoard();
    var mockSolution = MockSolution();
    var vua = ValueNotifier(UserAnswer.start());

    when(mockSolution.uniqueWords()).thenReturn(['abc'].toSet());

    GameInfo info = GameInfo(
      parameters: mockParameters,
      board: mockBoard,
      solution: mockSolution,
      userAnswer: vua,
    );

    var text = TestWidget();

    Provider provider = Provider(
      gameInfo: info,
      child: text,
    );

    Widget w = testableWidget(child: provider);
    await tester.pumpWidget(w);

    var label0 = find.text('0');
    expect(label0, findsOneWidget);

    var nextAnswer = UserAnswer(vua.value, 'abc', true);
    vua.value = nextAnswer;

    await tester.pumpAndSettle();

    var label1 = find.text('1');
    expect(label1, findsOneWidget);
  });
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gameInfo = Provider.of(context);
    var answer = gameInfo.userAnswer;
    return Text(answer.value.uniqueWords().length.toString());
  }
}
