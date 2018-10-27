import 'package:flutter/material.dart';

class ToggleSetting {
  static List<Widget> create(ValueNotifier<bool> notifier, IconData icon) =>
      <Widget>[
        Icon(icon, size: 40.0),
        Container(),
        Container(
          child: Switch(
            value: notifier.value,
            onChanged: (bool value) => notifier.value = value,
          ),
        ),
      ];
}
