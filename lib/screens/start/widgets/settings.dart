import 'package:bnoggles/screens/start/widgets/board_size_slider.dart';
import 'package:bnoggles/screens/start/widgets/time_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/provider.dart';

import 'package:bnoggles/utils/solution.dart';

const int _maxLength = 8;

class SettingsGrid extends StatelessWidget {
  final ValueNotifier<int> _time;
  final ValueNotifier<int> _size;

  SettingsGrid(this._time, this._size);

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
              children: [
                TableCell(child: TimeIcon()),
                TableCell(child: TimeText(time: _time)),
                TableCell(child: TimeSlider()),
              ],
            ),
            TableRow(
              children: [
                Container(height: 50.0),
                Container(),
                Container(),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: BoardIcon()),
                TableCell(child: BoardText(size: _size)),
                TableCell(child: BoardSizeSlider()),
              ],
            ),
            TableRow(
              children: [
                Container(height: 50.0),
                Container(),
                Container(),
              ],
            ),
          ],
        ));
  }
}
