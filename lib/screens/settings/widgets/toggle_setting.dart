import 'package:flutter/material.dart';

class ToggleSetting {
  static List<Widget> create(ValueNotifier<bool> notifier, IconData icon) =>
      <Widget>[
        Icon(icon, size: 40.0),
        Container(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: notifier.value,
              onChanged: (bool value) => notifier.value = value,
            ),
          ],
        ),
      ];
}
