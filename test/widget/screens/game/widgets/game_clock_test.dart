// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helper.dart';

void main() {
  testWidgets('clock time', (WidgetTester tester) async {
    var controller = AnimationController(
      vsync: tester,
    );

    Clock clock = Clock(
      showResultScreen: () {},
      controller: controller,
      startTime: 100,
    );
    await tester.pumpWidget(testableWidget(child: clock));

    expect(find.text('1:41'), findsOneWidget);

    controller.value = .5;
    await tester.pump();
    expect(find.text('0:51'), findsOneWidget);

    controller.value = 1;
    await tester.pump();
    expect(find.text('0:00'), findsOneWidget);
  });

  testWidgets('callback when finished', (WidgetTester tester) async {
    bool finished = false;

    var controller = AnimationController(
      vsync: tester,
    );

    Clock clock = Clock(
      showResultScreen: () {
        finished = true;
      },
      controller: controller,
      startTime: 100,
    );
    await tester.pumpWidget(testableWidget(child: clock));

    expect(finished, false);

    controller.value = .5;
    expect(finished, false);

    controller.value = 1;
    expect(finished, true);
  });
}
