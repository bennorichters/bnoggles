// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../widget_test_helper.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('...', (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(900, 1200));

    GameInfo info = createGameInfo();
    GameScreen screen = GameScreen(
      gameInfo: info,
    );

    Widget w = testableWidgetWithMediaQuery(
      child: screen,
      width: 900,
      height: 1200,
    );
    await tester.pumpWidget(w);

    var bnoggles = find.text("Bnoggles");
    expect(bnoggles, findsOneWidget);
  });
}
