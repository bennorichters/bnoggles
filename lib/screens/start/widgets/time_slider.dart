import 'package:bnoggles/screens/start/start_screen.dart';
import 'package:bnoggles/utils/helper/helper.dart';
import 'package:flutter/material.dart';

class TimeIcon extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Icon(Icons.timer);
  }
}

class TimeText extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Text("YES!");
  }
}

class TimeSlider extends StatefulWidget {
  @override
  _TimeSliderState createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> {
  static const int _startTime = 150;

  double _value = _startTime + .0;

  _onChanged(double value) {
    setState(() {
      _value = value;
    });
  }

  _onChangedEnd(double value, BuildContext context) {
    StartScreenState startScreen =
        context.ancestorStateOfType(const TypeMatcher<StartScreenState>());
    startScreen.setTime(value.floor());
  }

  @override
  build(BuildContext context) {
    return Container(
      width: 400.0,
        height: 200.0,
        padding: EdgeInsets.all(15.0),

        child: Slider(
          value: _value,
          min: 30.0,
          max: 600.0,
          divisions: 19,
          label: formatTime(_value.floor()),
          onChanged: _onChanged,
          onChangeEnd: (double value) => _onChangedEnd(value, context),
        ));
  }
}
