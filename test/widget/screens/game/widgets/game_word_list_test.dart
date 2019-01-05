// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_word_list.dart';
import 'package:bnoggles/utils/gamelogic/answer.dart' as Solution;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../widget_test_helper.dart';

class MockUserWord extends Mock implements Solution.UserWord {}

void main() {
  testWidgets('show first words in list', (WidgetTester tester) async {
    var p = List.generate(
        250,
        (i) => WordDisplay.neutral(
              word: i.toString(),
              screenHeight: 600,
            ));

    Widget w = WordList(
      words: p,
      scrollBackOnUpdate: true,
    );

    await tester.pumpWidget(testableWidget(child: w));
    expect(find.text('0'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('show new word', (WidgetTester tester) async {
    List<WordDisplay> words = List.generate(
        250,
        (i) => WordDisplay.neutral(
              word: i.toString(),
              screenHeight: 600,
            ));
    ValueNotifier<List<WordDisplay>> valueNotifier = ValueNotifier(words);

    Widget v = ValueListenableBuilder<List<WordDisplay>>(
      valueListenable: valueNotifier,
      builder: (context, value, child) => WordList(
            words: valueNotifier.value,
            scrollBackOnUpdate: true,
          ),
    );

    await tester.pumpWidget(testableWidget(child: v));
    words.insert(
        0,
        WordDisplay.neutral(
          word: 'abcde',
          screenHeight: 600,
        ));
    valueNotifier.value = words.toList();
    await tester.pumpAndSettle();
    expect(find.text('ABCDE'), findsOneWidget);
  });

  testWidgets('new word visible after first dragging left',
      (WidgetTester tester) async {
    List<WordDisplay> words = List.generate(
        250,
        (i) => WordDisplay.neutral(
              word: i.toString(),
              screenHeight: 600,
            ));
    ValueNotifier<List<WordDisplay>> valueNotifier = ValueNotifier(words);

    Widget v = ValueListenableBuilder<List<WordDisplay>>(
      valueListenable: valueNotifier,
      builder: (context, value, child) => WordList(
            words: valueNotifier.value,
            scrollBackOnUpdate: true,
          ),
    );

    await tester.pumpWidget(testableWidget(child: v));

    await tester.drag(find.text('10'), Offset(-300, 0));
    await tester.pumpAndSettle();
    words.insert(
        0,
        WordDisplay.neutral(
          word: 'abcde',
          screenHeight: 600,
        ));
    valueNotifier.value = words.toList();
    await tester.pumpAndSettle();

    expect(find.text('ABCDE'), findsOneWidget);
  });

  testWidgets('new word not visible after first dragging left',
      (WidgetTester tester) async {
    List<WordDisplay> words = List.generate(
        250,
        (i) => WordDisplay.neutral(
              word: i.toString(),
              screenHeight: 600,
            ));
    ValueNotifier<List<WordDisplay>> valueNotifier = ValueNotifier(words);

    Widget v = ValueListenableBuilder<List<WordDisplay>>(
      valueListenable: valueNotifier,
      builder: (context, value, child) => WordList(
            words: valueNotifier.value,
            scrollBackOnUpdate: false,
          ),
    );

    await tester.pumpWidget(testableWidget(child: v));

    await tester.drag(find.text('10'), Offset(-300, 0));
    await tester.pumpAndSettle();
    words.insert(
        0,
        WordDisplay.neutral(
          word: 'abcde',
          screenHeight: 600,
        ));
    valueNotifier.value = words.toList();
    await tester.pumpAndSettle();

    expect(find.text('ABCDE'), findsNothing);
  });

  testWidgets('WordDisplay toString finishes normally',
      (WidgetTester tester) async {
    WordDisplay.neutral(
      word: "abc",
      screenHeight: 600,
    ).toString();

    MockUserWord mockUserWord = MockUserWord();
    when(mockUserWord.word).thenReturn('abc');
    when(mockUserWord.evaluation).thenReturn(Solution.Evaluation.good);

    WordDisplay.fromUser(
      userWord: mockUserWord,
      screenHeight: 600,
    ).toString();
  });
}
