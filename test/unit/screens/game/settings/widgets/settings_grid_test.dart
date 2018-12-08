// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/settings/widgets/settings_grid.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:ui' as ui;

void main() {
  testWidgets('grid does not overflow', (WidgetTester tester) async {
    Preferences p = Preferences(
      ValueNotifier(0),
      ValueNotifier(300),
      ValueNotifier(3),
      ValueNotifier(2),
    );

    SettingsGrid grid = SettingsGrid(p);
    await tester.pumpWidget(testableWidget(grid, 900, 1200));
    await tester.pumpWidget(testableWidget(grid, 500, 592));
  });
}

Widget testableWidget(Widget child, double width, double height) => MaterialApp(
      home: Material(
        child: MediaQuery(
          data: MediaQueryData.fromWindow(ui.window).copyWith(
            size: Size(width, height),
          ),
          child: Center(
            child: Container(
              width: width,
              height: height,
              child: UnconstrainedBox(
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
