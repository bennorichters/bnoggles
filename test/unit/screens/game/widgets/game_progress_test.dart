// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_clock.dart';
import 'package:bnoggles/screens/game/widgets/game_progress.dart';
import 'package:bnoggles/screens/game/widgets/provider.dart';
import 'package:bnoggles/screens/game/widgets/word_count_overview.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/frequency.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../widget_test_helper.dart';

class MockSolution extends Mock implements Solution {}

void main() {
  testWidgets('finds Clock and WordCountOverview', (WidgetTester tester) async {
    var controller = AnimationController(
      vsync: tester,
    );

    var info = createGameInfo();
    var widget = Provider(
      gameInfo: info,
      child: GameProgress(controller, 100, () {}),
    );
    await tester.pumpWidget(testableWidget(child: widget));

    expect(find.byType(Clock), findsOneWidget);
    expect(find.byType(WordCountOverview), findsOneWidget);
  });
}

GameInfo createGameInfo() {
  var mockSolution = MockSolution();
  when(mockSolution.uniqueWords()).thenReturn(['abc'].toSet());
  when(mockSolution.minimalLength).thenReturn(2);
  when(mockSolution.frequency).thenReturn(Frequency.fromStrings([]));

  var vua = ValueNotifier(UserAnswer.start());

  return GameInfo(
    parameters: null,
    board: null,
    solution: mockSolution,
    userAnswer: vua,
  );
}
