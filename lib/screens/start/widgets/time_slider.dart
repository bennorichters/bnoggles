import 'package:bnoggles/screens/start/start_screen.dart';
import 'package:bnoggles/utils/helper/helper.dart';
import 'package:flutter/material.dart';

class TimeIcon extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Icon(Icons.timer, size: 40.0);
  }
}

class TimeText extends StatefulWidget {
  final ValueNotifier<int> time;
  TimeText({Key key, this.time}) : super(key: key);

  @override
  _TimeTextState createState() => _TimeTextState();
}

class _TimeTextState extends State<TimeText> {
  @override
  initState() {
    super.initState();
    widget.time.addListener(didValueChange);
  }

  didValueChange() => setState(() {});

  @override
  build(BuildContext context) {
    return Text(
      formatTime(widget.time.value),
      style: TextStyle(fontSize: 20.0),
    );
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
    return Slider(
      value: _value,
      min: 30.0,
      max: 600.0,
      divisions: 19,
      label: formatTime(_value.floor()),
      onChanged: _onChanged,
      onChangeEnd: (double value) => _onChangedEnd(value, context),
    );
  }
}
