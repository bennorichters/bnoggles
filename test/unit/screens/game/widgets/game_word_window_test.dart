// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_word_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helper.dart';

void main() {
  testWidgets('show first words in list', (WidgetTester tester) async {
    var p = List.generate(250, (i) => Word.neutral(i.toString()));

    Widget w = WordWindow(p);

    await tester.pumpWidget(testableWidget(child: w));
    expect(find.text('0'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('show new word', (WidgetTester tester) async {
    List<Word> words = List.generate(250, (i) => Word.neutral(i.toString()));
    ValueNotifier<List<Word>> valueNotifier = ValueNotifier(words);

    Widget v = ValueListenableBuilder<List<Word>>(
      valueListenable: valueNotifier,
      builder: (context, value, child) => WordWindow(valueNotifier.value),
    );

    await tester.pumpWidget(testableWidget(child: v));
    words.insert(0, Word.neutral('abcde'));
    valueNotifier.value = words.toList();
    await tester.pumpAndSettle();
    expect(find.text('ABCDE'), findsOneWidget);
  });

  testWidgets('new word visible after first dragging left',
      (WidgetTester tester) async {
    List<Word> words = List.generate(250, (i) => Word.neutral(i.toString()));
    ValueNotifier<List<Word>> valueNotifier = ValueNotifier(words);

    Widget v = ValueListenableBuilder<List<Word>>(
      valueListenable: valueNotifier,
      builder: (context, value, child) => WordWindow(valueNotifier.value),
    );

    await tester.pumpWidget(testableWidget(child: v));

    await tester.drag(find.text('10'), Offset(-300, 0));
    await tester.pumpAndSettle();
    words.insert(0, Word.neutral('abcde'));
    valueNotifier.value = words.toList();
    await tester.pumpAndSettle();

    expect(find.text('ABCDE'), findsOneWidget);
  });
}
