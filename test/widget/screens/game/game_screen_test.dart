// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:bnoggles/screens/game/widgets/game_board.dart';
import 'package:bnoggles/screens/game/widgets/game_progress.dart';
import 'package:bnoggles/screens/game/widgets/game_word_list_window.dart';
import 'package:bnoggles/screens/player/player_screen.dart';
import 'package:bnoggles/screens/result/result_screen.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../widget_test_helper.dart';
import '../../../test_helper.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('find Bnoggles, GameProgess, WordListWindow, GameBoard',
      (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(768, 1024));

    GameInfo info = createGameInfo();
    GameScreen screen = GameScreen(
      gameInfo: info,
    );

    Widget w = testableWidgetWithMediaQuery(
      child: screen,
      width: 768,
      height: 1024,
    );
    await tester.pumpWidget(w);

    expect(find.text("Bnoggles"), findsOneWidget);
    expect(find.byType(GameProgress), findsOneWidget);
    expect(find.byType(WordListWindow), findsOneWidget);
    expect(find.byType(GameBoard), findsOneWidget);
  });

  testWidgets('stop button is present and triggers navigation after tapped',
      (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(900, 1200));
    GameInfo info = createGameInfo();
    GameScreen screen = GameScreen(
      gameInfo: info,
    );

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: screen,
        navigatorObservers: [mockObserver],
      ),
    );

    expect(find.byIcon(Icons.stop), findsOneWidget);
    await tester.tap(find.byIcon(Icons.stop));

    await tester.pump();
    expect(find.byType(ResultScreen), findsOneWidget);
  });

  testWidgets('navigates to result screen when all words have been found',
      (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(900, 1200));
    GameInfo info = createGameInfo(words: ['abc']);
    GameScreen screen = GameScreen(
      gameInfo: info,
    );

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: screen,
        navigatorObservers: [mockObserver],
      ),
    );

    ValueNotifier<UserAnswer> userAnswer = info.userAnswer;
    userAnswer.value = userAnswer.value.add('abc', true);

    await tester.pump();
    expect(find.byType(ResultScreen), findsOneWidget);
  });

  testWidgets(
      'do not navigate to result screen when not all words have been found',
      (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(900, 1200));
    GameInfo info = createGameInfo(words: ['abc', 'def']);
    GameScreen screen = GameScreen(
      gameInfo: info,
    );

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: screen,
        navigatorObservers: [mockObserver],
      ),
    );

    ValueNotifier<UserAnswer> userAnswer = info.userAnswer;
    userAnswer.value = userAnswer.value.add('abc', true);

    await tester.pump();
    expect(find.byType(ResultScreen), findsNothing);
  });

  testWidgets('navigate to result screen when time runs out',
      (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(900, 1200));
    GameInfo info = createGameInfo(words: ['abc', 'def']);
    GameScreen screen = GameScreen(
      gameInfo: info,
    );

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: screen,
        navigatorObservers: [mockObserver],
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(ResultScreen), findsOneWidget);
  });

  testWidgets('game screen does not time out when no time limit',
      (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(900, 1200));

    await tester.pumpWidget(testableWidgetWithMediaQuery(
      child: GameScreen(
        gameInfo: createGameInfo(
          hasTimeLimit: false,
        ),
      ),
      width: 768,
      height: 1024,
    ));

    expect(find.text('–:––'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('–:––'), findsOneWidget);
  });

  testWidgets(
      'navigate to next player screen when time runs out '
      'but not all players played', (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(900, 1200));

    GameScreen screen = GameScreen(
      gameInfo: createGameInfo(
        words: ['abc', 'def'],
        numberOfPlayers: 3,
        currentPlayer: 1,
      ),
    );

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: screen,
        navigatorObservers: [mockObserver],
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(PlayerScreen), findsOneWidget);
  });
}
