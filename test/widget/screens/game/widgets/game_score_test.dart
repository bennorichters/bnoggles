// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_info_provider.dart';
import 'package:bnoggles/screens/game/widgets/game_score.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_helper.dart';
import '../../../widget_test_helper.dart';

void main() {
  testWidgets('finds right score', (WidgetTester tester) async {
    GameInfo gameInfo = createGameInfo(
      words: ['ab'],
    );

    await tester.pumpWidget(testableWidget(
        child: GameInfoProvider(
      gameInfo: gameInfo,
      child: GameScore(
        height: 20,
      ),
    )));

    expect(find.text('0'), findsOneWidget);

    gameInfo.userAnswer.value = gameInfo.userAnswer.value.add('ab', true);
    await tester.pumpAndSettle();

    expect(find.text('9'), findsOneWidget);
  });
}
