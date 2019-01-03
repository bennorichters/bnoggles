// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/settings/widgets/settings_grid.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helper.dart';

void main() {
  testWidgets('grid does not overflow', (WidgetTester tester) async {
    Preferences mp = createMockPreferences();

    SettingsGrid grid = SettingsGrid(mp);
    await tester.pumpWidget(testableConstrainedWidget(
      child: grid,
      width: 900,
      height: 1200,
    ));
    await tester.pumpWidget(testableConstrainedWidget(
      child: grid,
      width: 500,
      height: 592,
    ));
  });
}
