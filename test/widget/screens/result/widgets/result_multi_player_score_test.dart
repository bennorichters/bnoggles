// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/result/widgets/result_multi_player_score.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../widget_test_helper.dart';

class MockScoreSheet extends Mock implements ScoreSheet {}

void main() {
  testWidgets('find numbers', (WidgetTester tester) async {
    MockScoreSheet m1 = MockScoreSheet();
    when(m1.availableWords).thenReturn(10);
    when(m1.foundWords).thenReturn(6);

    MockScoreSheet m2 = MockScoreSheet();
    when(m2.availableWords).thenReturn(10);
    when(m2.foundWords).thenReturn(9);

    MockScoreSheet m3 = MockScoreSheet();
    when(m3.availableWords).thenReturn(10);
    when(m3.foundWords).thenReturn(7);

    MockScoreSheet m4 = MockScoreSheet();
    when(m4.availableWords).thenReturn(10);
    when(m4.foundWords).thenReturn(8);

    await tester.pumpWidget(testableWidget(
      child: ResultMultiPlayerScore(
        scores: [m1, m2, m3, m4],
      ),
    ));

    expect(find.text('10'), findsOneWidget);

    // Scores
    var high = find.text('9');
    expect(high, findsOneWidget);

    high = numberTest(tester, 8, high);
    high = numberTest(tester, 7, high);
    high = numberTest(tester, 6, high);

    // Players
    high = find.text('2');
    expect(high, findsOneWidget);

    high = numberTest(tester, 4, high);
    high = numberTest(tester, 3, high);
    high = numberTest(tester, 1, high);
  });
}

Finder numberTest(WidgetTester tester, int lowNumber, Finder high) {
  var low = find.text(lowNumber.toString());
  expect(low, findsOneWidget);
  expect(tester.getCenter(low).dy > tester.getCenter(high).dy, true);

  return low;
}