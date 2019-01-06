// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_progress.dart';
import 'package:bnoggles/screens/game/widgets/game_info_provider.dart';
import 'package:bnoggles/screens/game/widgets/word_count_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_helper.dart';
import '../../../widget_test_helper.dart';

void main() {
  testWidgets('finds time widget and WordCountOverview',
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(
        child: GameInfoProvider(
      gameInfo: createGameInfo(),
      child: GameProgress(
        blockHeight: 20,
        wordCountFontSize: 10,
        timeWidget: Text('just testing'),
      ),
    )));

    expect(find.text('just testing'), findsOneWidget);
    expect(find.byType(WordCountOverview), findsOneWidget);
  });
}
