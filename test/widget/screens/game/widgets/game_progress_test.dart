// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_clock.dart';
import 'package:bnoggles/screens/game/widgets/game_progress.dart';
import 'package:bnoggles/screens/game/widgets/game_info_provider.dart';
import 'package:bnoggles/screens/game/widgets/word_count_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helper.dart';

void main() {
  testWidgets('finds Clock and WordCountOverview', (WidgetTester tester) async {
    var controller = AnimationController(
      vsync: tester,
    );

    var info = createGameInfo();
    var widget = GameInfoProvider(
      gameInfo: info,
      child: GameProgress(
        timeWidget: Text('just testing'),
      ),
    );
    await tester.pumpWidget(testableWidget(child: widget));

    expect(find.text('just testing'), findsOneWidget);
    expect(find.byType(WordCountOverview), findsOneWidget);
  });
}
