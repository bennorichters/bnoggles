// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_board.dart';
import 'package:bnoggles/screens/game/widgets/game_info_provider.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_helper.dart';
import '../../../widget_test_helper.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Find word', (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(600, 800));
    GameInfo info = createGameInfo();
    await tester.pumpWidget(testableGameBoard(info));

    expect(info.userAnswer.value.contains('abc'), false);

    var offsetStart = tester.getCenter(find.text('A'));
    var offSetMiddle = tester.getCenter(find.text('B'));
    var offsetEnd = tester.getCenter(find.text('C'));
    var vector1 = offSetMiddle - offsetStart;
    var vector2 = offsetEnd - offSetMiddle;

    TestGesture gesture = await tester.startGesture(offsetStart);
    await gesture.moveBy(vector1);
    await gesture.moveBy(vector2);
    await gesture.up();

    await tester.pumpAndSettle();

    expect(info.userAnswer.value.contains('abc'), true);
  });

  testWidgets('Do not find word', (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(600, 800));
    GameInfo info = createGameInfo();
    await tester.pumpWidget(testableGameBoard(info));

    expect(info.userAnswer.value.contains('abc'), false);

    var offsetStart = tester.getCenter(find.text('A'));
    var offSetMiddle = tester.getCenter(find.text('D'));
    var offsetEnd = tester.getCenter(find.text('G'));
    var vector1 = offSetMiddle - offsetStart;
    var vector2 = offsetEnd - offSetMiddle;

    TestGesture gesture = await tester.startGesture(offsetStart);
    await gesture.moveBy(vector1);
    await gesture.moveBy(vector2);
    await gesture.up();

    await tester.pumpAndSettle();

    expect(info.userAnswer.value.contains('abc'), false);
    expect(info.userAnswer.value.contains('adg'), false);
  });
}

Widget testableGameBoard(GameInfo info) => testableWidgetWithMediaQuery(
      child: GameInfoProvider(
        gameInfo: info,
        child: const GameBoard(),
      ),
      width: 600.0,
      height: 800.0,
    );
