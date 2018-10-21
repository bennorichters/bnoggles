import 'package:bnoggles/screens/start/widgets/board_size_slider.dart';
import 'package:bnoggles/screens/start/widgets/time_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/provider.dart';

import 'package:bnoggles/utils/solution.dart';

const int _maxLength = 8;

class SettingsGrid extends StatelessWidget {
  final ValueNotifier<int> _time;

  SettingsGrid(this._time);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.red)),
        padding: EdgeInsets.all(15.0),
        height: 600.0,
        child: Table(
          border: TableBorder.all(width: 1.0, color: Colors.orange),
          children: [
            TableRow(
              children: [
                TableCell(child: TimeIcon()),
                TableCell(child: TimeText(time: _time)),
                TableCell(child: TimeSlider()),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: BoardIcon()),
                TableCell(child: BoardText()),
                TableCell(child: BoardSizeSlider()),
              ],
            ),
          ],
        ));
  }
}
