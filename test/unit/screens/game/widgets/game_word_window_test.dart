// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_clock.dart';
import 'package:bnoggles/screens/game/widgets/game_word_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helper.dart';

void main() {
  testWidgets('show new words', (WidgetTester tester) async {
    WordsProvider p =
        () => List.generate(250, (i) => Word.neutral(i.toString()));
    ValueNotifier<int> n = ValueNotifier(0);

    Widget w = WordWindow(p, n);

    await tester.pumpWidget(testableWidget(child: w));
    expect(find.text('0'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('dragging words from right to left', (WidgetTester tester) async {
    WordsProvider p =
        () => List.generate(250, (i) => Word.neutral(i.toString()));
    ValueNotifier<int> n = ValueNotifier(0);

    Widget w = WordWindow(p, n);

    await tester.pumpWidget(testableWidget(child: w));

    bool found = true;
    int i = -1;
    while (found) {
      i++;
      found =
          findsOneWidget.matches(find.text(i.toString()), <dynamic, dynamic>{});
    }

    await tester.drag(find.text((i - 1).toString()), Offset(-100, 0));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsNothing);
    expect(find.text(i.toString()), findsOneWidget);
  });
}
