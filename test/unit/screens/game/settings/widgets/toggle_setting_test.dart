// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/settings/widgets/toggle_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  testWidgets('find icon', (WidgetTester tester) async {
    ValueNotifier<bool> v = ValueNotifier(false);
    var list = toggleSetting(
      notifier: v,
      icon: Icons.ac_unit,
    );
    await tester.pumpWidget(testable(children: list));

    var icon = find.byIcon(Icons.ac_unit);
    expect(icon, findsOneWidget);
  });

  testWidgets('toggle switch', (WidgetTester tester) async {
    ValueNotifier<bool> v = ValueNotifier(false);
    var list = toggleSetting(
      notifier: v,
      icon: Icons.ac_unit,
    );
    await tester.pumpWidget(testable(children: list));

    var toggleWidget = find.byType(Switch);
    expect(toggleWidget, findsOneWidget);

    expect(v.value, false);

    await tester.tap(toggleWidget);
    await tester.pump();
    expect(v.value, true);

    await tester.tap(toggleWidget);
    await tester.pump();
    expect(v.value, false);

    await tester.tap(toggleWidget);
    await tester.pump();
    expect(v.value, true);

    await tester.tap(toggleWidget);
    await tester.pump();
    expect(v.value, false);
  });
}
