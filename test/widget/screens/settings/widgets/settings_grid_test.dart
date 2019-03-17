// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/settings/widgets/settings_grid.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_helper.dart';
import '../../../widget_test_helper.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('grid does not overflow', (WidgetTester tester) async {
    double width = 500;
    double height = 592;

    await binding.setSurfaceSize(Size(width, height));

    Preferences mp = createMockPreferences();

    SettingsGrid grid = SettingsGrid(mp);
    var widget = testableWidgetWithMediaQuery(
      child: grid,
      width: width,
      height: height,
    );

    await tester.pumpWidget(widget);
  });
}
