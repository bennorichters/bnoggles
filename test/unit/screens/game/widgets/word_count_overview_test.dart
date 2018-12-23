// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/provider.dart';
import 'package:bnoggles/screens/game/widgets/word_count_overview.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helper.dart';

void main() {
  testWidgets('find 14 number infoboxes', (WidgetTester tester) async {
    GameInfo info = createGameInfo([]);
    await tester.pumpWidget(testableWordCountView(info));

    for (int i = 0; i < 14; i++) {
      expect(find.byKey(Key('wordcount' + i.toString())), findsOneWidget);
    }
  });

  testWidgets('correct word count numbers', (WidgetTester tester) async {
    GameInfo info =
        createGameInfo(['12', '23', '123', '1234567', '1234567890']);
    await tester.pumpWidget(testableWordCountView(info));

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
}

Widget testableWordCountView(GameInfo info) => testableWidget(
      child: Provider(
        gameInfo: info,
        child: WordCountOverview(),
      ),
    );
