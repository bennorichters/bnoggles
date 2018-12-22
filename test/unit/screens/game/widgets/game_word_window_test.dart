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
  testWidgets('show first words in list', (WidgetTester tester) async {
    WordsProvider p =
        () => List.generate(250, (i) => Word.neutral(i.toString()));
    ValueNotifier<int> n = ValueNotifier(0);

    Widget w = WordWindow(p, n);

    await tester.pumpWidget(testableWidget(child: w));
    expect(find.text('0'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('show new word', (WidgetTester tester) async {
    List<Word> words = List.generate(250, (i) => Word.neutral(i.toString()));
    WordsProvider p = () => words;

    ValueNotifier<int> n = ValueNotifier(0);

    Widget w = WordWindow(p, n);

    await tester.pumpWidget(testableWidget(child: w));
    words.insert(0, Word.neutral('abcde'));
    n.value = 1;
    await tester.pumpAndSettle();
    expect(find.text('ABCDE'), findsOneWidget);
  });

  testWidgets('new word visible after first dragging left',
      (WidgetTester tester) async {
    List<Word> words = List.generate(250, (i) => Word.neutral(i.toString()));
    WordsProvider p = () => words;

    ValueNotifier<int> n = ValueNotifier(0);

    Widget w = WordWindow(p, n);

    await tester.pumpWidget(testableWidget(child: w));
    await tester.drag(find.text('10'), Offset(-300, 0));
    await tester.pumpAndSettle();
    words.insert(0, Word.neutral('abcde'));
    n.value = 1;
    await tester.pumpAndSettle();

    expect(find.text('ABCDE'), findsOneWidget);
  });
}
