import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/settings/widgets/integer_slider.dart';
import 'package:bnoggles/screens/settings/widgets/toggle_setting.dart';
import 'package:bnoggles/utils/helper/helper.dart';
import 'package:bnoggles/utils/preferences.dart';

class SettingsGrid extends StatelessWidget {
  final Preferences preferences;

  SettingsGrid(this.preferences);

  TableRow _emptyLine() => TableRow(
        children: [
          Container(height: 50.0),
          Container(),
          Container(),
        ],
      );

  @override
  Widget build(BuildContext context) {
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
            children: IntSlider.create(
              preferences.time,
              Icons.timer,
              formatTime,
              min: 30,
              max: 600,
              stepSize: 30,
            ),
          ),
          _emptyLine(),
          TableRow(
            children: IntSlider.create(
              preferences.size,
              Icons.grid_on,
              (i) => '$i x $i',
              min: 3,
              max: 6,
            ),
          ),
          _emptyLine(),
          TableRow(
            children: IntSlider.create(
              preferences.length,
              Icons.text_rotation_none,
              (i) => '$i+',
              min: 2,
              max: 4,
            ),
          ),
          _emptyLine(),
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
