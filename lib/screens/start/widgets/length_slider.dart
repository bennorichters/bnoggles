import 'package:bnoggles/screens/start/start_screen.dart';
import 'package:flutter/material.dart';

class LengthIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.text_rotation_none, size: 40.0,);
  }
}

class LengthText extends StatefulWidget {
  final ValueNotifier<int> length;
  LengthText({Key key, this.length}) : super(key: key);

  @override
  LengthTextState createState() => LengthTextState();
}

class LengthTextState extends State<LengthText> {
  @override
  void initState() {
    super.initState();
    widget.length.addListener(didValueChange);
  }

  void didValueChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Text('${widget.length.value}+',
        style: TextStyle(fontSize: 20.0));
  }
}

class LengthSlider extends StatefulWidget {
  @override
  _LengthSliderState createState() => _LengthSliderState();
}

class _LengthSliderState extends State<LengthSlider> {
  static const int _startSize = 2;

  double _value = _startSize + .0;

  void _onChanged(double value) {
    setState(() {
      _value = value;
    });
  }

  void _onChangedEnd(double value, BuildContext context) {
    StartScreenState startScreen =
        context.ancestorStateOfType(const TypeMatcher<StartScreenState>());
    startScreen.setLength(value.floor());
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _value,
      min: 2.0,
      max: 4.0,
      divisions: 2,
      label: '${_value.floor()}+',
      onChanged: _onChanged,
      onChangeEnd: (double value) => _onChangedEnd(value, context),
    );
  }
}
