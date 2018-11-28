// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

List<Widget> intSlider({
  @required ValueNotifier<int> notifier,
  @required IconData icon,
  @required LabelRenderer label,
  @required int min,
  @required int max,
  int stepSize = 1,
}) {
  var divisions = (max - min) ~/ stepSize;
  assert(min + stepSize * divisions == max,
      'Inconsistent slider parameters: $max - $min is not divisible by $stepSize');
  return [
    Icon(icon, size: 40.0),
    _Label(label: label, notifier: notifier),
    _Slider(
      label: label,
      notifier: notifier,
      min: min,
      max: max,
      divisions: divisions,
    ),
  ];
}

class _Label extends StatefulWidget {
  _Label({Key key, this.notifier, this.label}) : super(key: key);
  final ValueNotifier<int> notifier;
  final LabelRenderer label;

  @override
  _LabelState createState() => _LabelState();
}

class _LabelState extends State<_Label> {
  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_didValueChange);
  }

  void _didValueChange() => setState(() {});

  @override
  Widget build(BuildContext context) => Text(
        widget.label(widget.notifier.value),
        style: TextStyle(fontSize: 20.0),
      );

  @override
  void dispose() {
    widget.notifier.removeListener(_didValueChange);
    super.dispose();
  }
}

class _Slider extends StatefulWidget {
  _Slider(
      {Key key, this.notifier, this.label, this.min, this.max, this.divisions})
      : super(key: key);

  final ValueNotifier<int> notifier;
  final int min;
  final int max;
  final int divisions;
  final LabelRenderer label;

  @override
  _SliderState createState() => _SliderState();
}

class _SliderState extends State<_Slider> {
  ValueNotifier<int> _notifier;
  double _value;
  double _min;
  double _max;
  int _divisions;
  LabelRenderer _label;

  @override
  void initState() {
    super.initState();
    _value = widget.notifier.value + .0;
    _notifier = widget.notifier;
    _min = widget.min + .0;
    _max = widget.max + .0;
    _divisions = widget.divisions;
    _label = widget.label;
  }

  void _onChanged(double value) {
    setState(() {
      _value = value;
    });
  }

  void _onChangedEnd(double value) {
    _notifier.value = value.floor();
  }

  @override
  Widget build(BuildContext context) => Slider(
        value: _value,
        min: _min,
        max: _max,
        divisions: _divisions,
        label: _label(_value.floor()),
        onChanged: _onChanged,
        onChangeEnd: _onChangedEnd,
      );
}

typedef String LabelRenderer(int value);
