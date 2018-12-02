// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:bnoggles/screens/settings/widgets/integer_slider.dart';
import 'package:bnoggles/screens/settings/widgets/language_setting.dart';
import 'package:bnoggles/screens/settings/widgets/toggle_setting.dart';
import 'package:bnoggles/utils/format_time/format_time.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// The height of an empty line should decrease for smaller screen sizes. The
// maximum height is 50. Empirically found values for the height of some
// devices are:
//
// - for screen height 683.4 (e.g. Pixel) the empty line height is 50
// - for screen height 592.0 (e.g. Nexus 4) the empty line height is 20
//
// emptyLineHeight = A x screenHeight + B
const double _a = (20.0 - 50.0) / (592.0 - 683.4);
const double _b = 20.0 - _a * 592.0;

class SettingsGrid extends StatelessWidget {
  SettingsGrid(this.preferences);
  final Preferences preferences;

  TableRow _emptyLine(double emptyLineHeight) => TableRow(
        children: [
          Container(height: min(50.0, emptyLineHeight)),
          Container(),
          Container(),
        ],
      );

  @override
  Widget build(BuildContext context) {
    // See above
    MediaQueryData data = MediaQuery.of(context);
    double screenHeight = data.size.height;
    double emptyLineHeight = _a * screenHeight + _b;

    return Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.all(5.0),
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(50.0),
          1: FixedColumnWidth(60.0),
          2: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: languageOptions(
              notifier: preferences.language,
              icon: Icons.language,
            ),
          ),
          _emptyLine(emptyLineHeight),
          TableRow(
            children: intSlider(
              notifier: preferences.time,
              icon: Icons.timer,
              label: formatTime,
              min: 30,
              max: 600,
              stepSize: 30,
            ),
          ),
          _emptyLine(emptyLineHeight),
          TableRow(
            children: intSlider(
              notifier: preferences.boardWidth,
              icon: Icons.grid_on,
              label: (i) => '$i x $i',
              min: 3,
              max: 6,
            ),
          ),
          _emptyLine(emptyLineHeight),
          TableRow(
            children: intSlider(
              notifier: preferences.minimalWordLength,
              icon: Icons.text_rotation_none,
              label: (i) => '$i+',
              min: 2,
              max: 4,
            ),
          ),
          _emptyLine(emptyLineHeight),
          TableRow(
            children: toggleSetting(
              icon: Icons.assistant,
              notifier: preferences.hints,
            ),
          ),
        ],
      ),
    );
  }
}
