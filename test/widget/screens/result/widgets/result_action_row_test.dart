// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/result/widgets/result_action_row.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../widget_test_helper.dart';

class MockGameParameters extends Mock implements GameParameters {}

void main() {
  testWidgets('settings and play again buttons present',
      (WidgetTester tester) async {
    MockGameParameters mockGameParameters = MockGameParameters();
    when(mockGameParameters.hints).thenReturn(true);
    when(mockGameParameters.boardWidth).thenReturn(3);
    when(mockGameParameters.time).thenReturn(100);
    when(mockGameParameters.languageCode).thenReturn('nl');
    when(mockGameParameters.minimalWordLength).thenReturn(2);

    await tester.pumpWidget(testableWidget(
        child: ResultActionRow(
      parameters: () => mockGameParameters,
    )));

    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });

  testWidgets('navigate back to /', (WidgetTester tester) async {
    GameInfo info = createGameInfo();
    final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
      '/': (BuildContext context) => _TestHomeWidget(),
      '/next': (BuildContext context) =>
          ResultActionRow(parameters: () => info.parameters),
    };

    await tester.pumpWidget(MaterialApp(routes: routes));
    await tester.tap(find.text('BUTTON'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.byType(_TestHomeWidget), findsOneWidget);
  });
}

class _TestHomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/next');
      },
      child: const Text('BUTTON'),
    );
  }
}
