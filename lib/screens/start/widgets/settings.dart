import 'package:bnoggles/screens/start/widgets/integer_slider.dart';
import 'package:bnoggles/utils/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SettingsGrid extends StatelessWidget {
  final ValueNotifier<int> _time;
  final ValueNotifier<int> _size;
  final ValueNotifier<int> _length;

  SettingsGrid(this._time, this._size, this._length);

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
                    _time, Icons.timer, formatTime, 30, 600, 19)),
            _emptyLine(),
            TableRow(
                children: IntSlider.create(
                    _size, Icons.grid_on, (i) => '$i x $i', 3, 6, 3)),
            _emptyLine(),
            TableRow(
                children: IntSlider.create(
                    _length, Icons.text_rotation_none, (i) => '$i+', 2, 4, 2)),
            _emptyLine(),
          ],
        ));
  }
}
