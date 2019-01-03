// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/result/result_screen.dart';
import 'package:bnoggles/screens/result/widgets/result_all_words_list.dart';
import 'package:bnoggles/screens/result/widgets/result_action_row.dart';
import 'package:bnoggles/screens/result/widgets/result_board.dart';
import 'package:bnoggles/screens/result/widgets/result_multi_player_score.dart';
import 'package:bnoggles/screens/result/widgets/result_single_player_score.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_helper.dart';
import '../../widget_test_helper.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('find all elements for single player',
      (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(768, 1024));

    GameInfo info = createGameInfo();
    ResultScreen screen = ResultScreen(
      gameInfo: info,
    );

    Widget w = testableWidgetWithMediaQuery(
      child: screen,
      width: 768,
      height: 1024,
    );
    await tester.pumpWidget(w);

    expect(find.text("Bnoggles"), findsOneWidget);
    expect(find.byType(ResultAllWordsList), findsOneWidget);
    expect(find.byType(ResultSinglePlayerScore), findsOneWidget);
    expect(find.byType(ResultBoard), findsOneWidget);
    expect(find.byType(ResultActionRow), findsOneWidget);
  });

  testWidgets('find multi mlayer overview for multi playera',
      (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(768, 1024));

    ResultScreen screen = ResultScreen(
      gameInfo: createGameInfo(
        numberOfPlayers: 2,
      ),
    );

    Widget w = testableWidgetWithMediaQuery(
      child: screen,
      width: 768,
      height: 1024,
    );
    await tester.pumpWidget(w);

    expect(find.byType(ResultMultiPlayerScore), findsOneWidget);
  });

  testWidgets('tap play button', (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(768, 1024));

    _registerLanguageLoader();

    GameInfo info = createGameInfo();
    ResultScreen screen = ResultScreen(
      gameInfo: info,
    );

    Widget w = testableWidgetWithMediaQuery(
      child: screen,
      width: 768,
      height: 1024,
    );
    await tester.pumpWidget(w);

    tester.tap(find.byIcon(Icons.play_arrow));
  });
}

void _registerLanguageLoader() {
  Map<String, String> frequencies = {
    'nl': '{"a": 1, "b": 1, "c": 1}',
  };

  Map<String, String> words = {
    'nl': 'ab\nac\nbc\ncbabc',
  };

  var loader = LanguageLoader(
    characterSequenceFrequencies: (c) => Future<String>.value(frequencies[c]),
    availableWords: (c) => Future<String>.value(words[c]),
  );

  Language.registerLoader(loader);
}
