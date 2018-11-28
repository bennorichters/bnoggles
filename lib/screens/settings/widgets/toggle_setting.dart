// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// Creates a list of three widgets; an [Icon], a [Container] and a [Switch].
///
/// The user can toggle the value of [notifier] by tapping the switch.
List<Widget> toggleSetting({
  @required IconData icon,
  @required ValueNotifier<bool> notifier,
}) =>
    [
      Icon(icon, size: 40.0),
      Container(),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _HintSwitch(
            notifier: notifier,
          ),
        ],
      ),
    ];

class _HintSwitch extends StatefulWidget {
  _HintSwitch({Key key, this.notifier}) : super(key: key);
  final ValueNotifier<bool> notifier;

  @override
  State<StatefulWidget> createState() => _HintSwitchState();
}

class _HintSwitchState extends State<_HintSwitch> {
  @override
  Widget build(BuildContext context) => Switch(
        value: widget.notifier.value,
        onChanged: (bool isOn) => setState(() {
              widget.notifier.value = isOn;
            }),
      );
}
