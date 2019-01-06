// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/result/widgets/result_multi_player_score.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helper.dart';

void main() {
  testWidgets('find numbers', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(
      child: ResultMultiPlayerScore(
        availableWordsCount: 10,
        foundWords: [6, 9, 7, 8],
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