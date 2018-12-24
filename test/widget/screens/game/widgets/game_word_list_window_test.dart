// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_word_list_window.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
