// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:bnoggles/utils/language.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:bnoggles/widgets/start_game_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../widget_test_helper.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('finds play button', (WidgetTester tester) async {
    GameParameters p = createMockParameters(hints: false);
    await tester.pumpWidget(testableWidget(
      child: StartGameButton(
        parameterProvider: () => p,
        replaceScreen: false,
      ),
    ));

    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });

  testWidgets('tap play button pushes to next screen',
      (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(768, 1024));

    _registerLanguageLoader();

    GameParameters p = createMockParameters(hints: false);

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: StartGameButton(
          parameterProvider: () => p,
          replaceScreen: false,
        ),
        navigatorObservers: [mockObserver],
      ),
    );

    verify(mockObserver.didPush(any, any));
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pumpAndSettle();
    verify(mockObserver.didPush(any, any));
  });

  testWidgets('tap play button replace by next screen',
      (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(768, 1024));

    _registerLanguageLoader();

    GameParameters p = createMockParameters(
      hints: false,
      hasTimeLimit: false,
    );

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: StartGameButton(
          parameterProvider: () => p,
          replaceScreen: true,
        ),
        navigatorObservers: [mockObserver],
      ),
    );

    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pumpAndSettle();
    verify(mockObserver.didReplace(
      newRoute: anyNamed('newRoute'),
      oldRoute: anyNamed('oldRoute'),
    ));

    expect(find.byType(GameScreen), findsOneWidget);
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
