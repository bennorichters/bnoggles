import 'package:bnoggles/screens/start/widgets/board_size_slider.dart';
import 'package:bnoggles/screens/start/widgets/time_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/provider.dart';

import 'package:bnoggles/utils/solution.dart';

const int _maxLength = 8;

class SettingsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.red)),
      padding: EdgeInsets.all(15.0),
        height: 600.0,
        child: GridView.builder(
          itemCount: 6,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 5.0,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black)),
              child: fromIndex(index),
            );
          },
        ));
  }

  fromIndex(int index) {
    switch (index) {
      case 0:
        return TimeIcon();
      case 1:
        return TimeText();
      case 2:
        return TimeSlider();
      case 3:
        return BoardIcon();
      case 4:
        return BoardText();
      case 5:
        return BoardSizeSlider();
      default:
        assert(false, "cannot be here");
    }
  }
}
