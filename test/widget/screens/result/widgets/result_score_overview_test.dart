// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/result/widgets/result_score_overview.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../widget_test_helper.dart';

class MockScoreSheet extends Mock implements ScoreSheet {}

void main() {
  testWidgets('find numbers', (WidgetTester tester) async {
    MockScoreSheet mockScoreSheet = MockScoreSheet();
    when(mockScoreSheet.availableWords).thenReturn(10);
    when(mockScoreSheet.foundWords).thenReturn(5);

    await tester.pumpWidget(testableWidget(
      child: ResultScoreOverview(
        scores: mockScoreSheet,
        fontSize: 10,
      ),
    ));

    expect(find.text('5'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });
}
