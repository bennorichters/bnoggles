import 'package:bnoggles/screens/start/start_screen.dart';
import 'package:bnoggles/utils/helper/helper.dart';
import 'package:flutter/material.dart';

class BoardIcon extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Icon(Icons.grid_on);
  }
}

class BoardText extends StatefulWidget {
  final ValueNotifier<int> size;
  BoardText({Key key, this.size}) : super(key: key);

  @override
  BoardTextState createState() => BoardTextState();
}

class BoardTextState extends State<BoardText> {
  @override
  initState() {
    super.initState();
    widget.size.addListener(didValueChange);
  }

  didValueChange() => setState(() {});

  @override
  build(BuildContext context) {
    return Text('${widget.size.value} x ${widget.size.value}');
  }
}

class BoardSizeSlider extends StatefulWidget {
  @override
  _BoardSizeSliderState createState() => _BoardSizeSliderState();
}

class _BoardSizeSliderState extends State<BoardSizeSlider> {
  static const int _startSize = 3;

  double _value = _startSize + .0;

  _onChanged(double value) {
    setState(() {
      _value = value;
    });
  }

  _onChangedEnd(double value, BuildContext context) {
    StartScreenState startScreen =
        context.ancestorStateOfType(const TypeMatcher<StartScreenState>());
    startScreen.setBoardWidth(value.floor());
  }

  @override
  build(BuildContext context) {
    return Slider(
      value: _value,
      min: 3.0,
      max: 6.0,
      divisions: 3,
      label: '${_value.floor()} x ${_value.floor()}',
      onChanged: _onChanged,
      onChangeEnd: (double value) => _onChangedEnd(value, context),
    );
  }
}