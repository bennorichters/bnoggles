// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:bnoggles/screens/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../widget_test_helper.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('find all elements', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(
      child: PlayerScreen(
        gameInfo: createGameInfo(
          numberOfPlayers: 4,
        ),
      ),
    ));

    expect(find.text('Bnoggles'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });

  testWidgets('find correct player number', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(
      child: PlayerScreen(
        gameInfo: createGameInfo(
          numberOfPlayers: 4,
          currentPlayer: 3,
        ),
      ),
    ));

    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('tap play button', (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(768, 1024));

    await tester.pumpWidget(testableWidget(
      child: PlayerScreen(
        gameInfo: createGameInfo(
          numberOfPlayers: 4,
          currentPlayer: 3,
          hasTimeLimit: false,
        ),
      ),
    ));

    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
  });
}
