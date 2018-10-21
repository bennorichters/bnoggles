import 'package:bnoggles/screens/start/start_screen.dart';
import 'package:bnoggles/utils/helper/helper.dart';
import 'package:flutter/material.dart';

class TimeSlider extends StatefulWidget {
  @override
  _TimeSliderState createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> {
  static const int _startTime = 150;

  double _value = _startTime + .0;
  String _clock = formatTime(_startTime);

  _onChanged(double value) {
    setState(() {
      _value = value;
      _clock = formatTime(value.floor());
    });
  }

  _onChangedEnd(double value, BuildContext context) {
    StartScreenState startScreen =
        context.ancestorStateOfType(const TypeMatcher<StartScreenState>());
    startScreen.setTime(value.floor());
  }

  @override
  build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Slider(
        value: _value,
        min: 30.0,
        max: 600.0,
        divisions: 19,
        label: formatTime(_value.floor()),
        onChanged: _onChanged,
        onChangeEnd: (double value) => _onChangedEnd(value, context),
      )),
      Container(child: Text(_clock))
    ]);
  }
}
