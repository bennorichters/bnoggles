// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_word_list_window.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/answer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_helper.dart';
import '../../../widget_test_helper.dart';

void main() {
  testWidgets('find hint words', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidgetWithProvider(
      child: WordListWindow(),
      info: createGameInfo(
        words: [
          'aap',
          'noot',
          'mies',
        ],
        hints: true,
      ),
    ));

    expect(find.text('AAP'), findsOneWidget);
    expect(find.text('NOOT'), findsOneWidget);
    expect(find.text('MIES'), findsOneWidget);
  });

  testWidgets('do not find hint words', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidgetWithProvider(
      child: WordListWindow(),
      info: createGameInfo(
        words: [
          'aap',
          'noot',
          'mies',
        ],
        hints: false,
      ),
    ));

    expect(find.text('AAP'), findsNothing);
    expect(find.text('NOOT'), findsNothing);
    expect(find.text('MIES'), findsNothing);
  });

  testWidgets('find user words', (WidgetTester tester) async {
    GameInfo info = createGameInfo(
        words: [
          'aap',
          'noot',
          'mies',
        ],
        hints: false,
      );

    await tester.pumpWidget(testableWidgetWithProvider(
      child: WordListWindow(),
      info: info,
    ));

    ValueNotifier<UserAnswer> userAnswer = info.userAnswer;

    expect(find.text('AAP'), findsNothing);

    userAnswer.value = userAnswer.value.add('aap', true);
    await tester.pumpAndSettle();
    expect(find.text('AAP'), findsOneWidget);

    userAnswer.value = userAnswer.value.add('wim', false);
    await tester.pumpAndSettle();
    expect(find.text('WIM'), findsOneWidget);
  });
}
