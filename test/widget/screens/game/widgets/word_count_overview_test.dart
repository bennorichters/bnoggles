// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/word_count_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_helper.dart';
import '../../../widget_test_helper.dart';

void main() {
  testWidgets('find 14 number infoboxes', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidgetWithProvider(
      child: WordCountOverview(),
    ));

    for (int i = 0; i < 14; i++) {
      expect(find.byKey(Key('wordcount' + i.toString())), findsOneWidget);
    }
  });

  testWidgets('correct word count numbers', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidgetWithProvider(
      child: WordCountOverview(),
      info: createGameInfo(
        words: ['12', '23', '123', '1234567', '1234567890'],
      ),
    ));

    var countMap = {
      2: 2,
      3: 1,
      7: 1,
      8: 1,
    };

    for (int wordLength = 2; wordLength <= 8; wordLength++) {
      int index = wordLength + 5;
      int count = countMap[wordLength] ?? 0;
      expect(
        find.descendant(
          of: find.byKey(Key('wordcount' + index.toString())),
          matching: find.text(count.toString()),
        ),
        findsOneWidget,
      );
    }
  });

  testWidgets('two x for word length 2 and 3', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidgetWithProvider(
      child: WordCountOverview(),
      info: createGameInfo(
        words: ['1234567', '1234567890'],
        minimalWordLength: 4,
      ),
    ));

    expect(find.text('x'), findsNWidgets(2));
 });
}
