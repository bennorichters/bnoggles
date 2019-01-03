// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/settings/settings_screen.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../widget_test_helper.dart';

void main() {
  testWidgets('bnoggles in app bar', (WidgetTester tester) async {
    Preferences mp = createMockPreferences();

    Widget w = testableWidget(child: SettingsScreen(preferences: mp,));
    await tester.pumpWidget(w);

    var bnoggles = find.text("Bnoggles");
    expect(bnoggles, findsOneWidget);
  });
}