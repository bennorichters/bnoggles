// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:bnoggles/screens/settings/widgets/language_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/settings/widgets/integer_slider.dart';
import 'package:bnoggles/screens/settings/widgets/toggle_setting.dart';
import 'package:bnoggles/utils/helper/helper.dart';
import 'package:bnoggles/utils/preferences.dart';

// The height of an empty line should decrease for smaller screen sizes. The
// maximum height is 50. Empirically found values for the height of some
// devices are:
//
// - for screen height 683.4 (e.g. Pixel) the empty line height is 50
// - for screen height 592.0 (e.g. Nexus 4) the empty line height is 20
//
// emptyLineHeight = A x screenHeight + B
const double a = (20.0 - 50.0) / (592.0 - 683.4);
const double b = 20.0 - a * 592.0;

class SettingsGrid extends StatelessWidget {
  final Preferences preferences;

  SettingsGrid(this.preferences);

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
    double emptyLineHeight = a * screenHeight + b;

    return Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.all(25.0),
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(50.0),
          1: FixedColumnWidth(60.0),
          2: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children:
                LanguageSetting.create(preferences.language, Icons.language),
          ),
          _emptyLine(emptyLineHeight),
          TableRow(
            children: IntSlider.create(
              preferences.time,
              Icons.timer,
              formatTime,
              min: 30,
              max: 600,
              stepSize: 30,
            ),
          ),
          _emptyLine(emptyLineHeight),
          TableRow(
            children: IntSlider.create(
              preferences.boardWidth,
              Icons.grid_on,
              (i) => '$i x $i',
              min: 3,
              max: 6,
            ),
          ),
          _emptyLine(emptyLineHeight),
          TableRow(
            children: IntSlider.create(
              preferences.minimalWordLength,
              Icons.text_rotation_none,
              (i) => '$i+',
              min: 2,
              max: 4,
            ),
          ),
          _emptyLine(emptyLineHeight),
          TableRow(
            children: ToggleSetting.create(
              preferences.hints,
              Icons.assistant,
            ),
          ),
        ],
      ),
    );
  }
}
