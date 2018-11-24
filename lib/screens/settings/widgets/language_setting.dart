// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class LanguageSetting {
  static List<Widget> create(ValueNotifier<int> notifier, IconData icon) {
    return <Widget>[
      Icon(icon, size: 40.0),
      Container(),
      _LanguageOptions(notifier: notifier),
    ];
  }
}

class _LanguageOptions extends StatefulWidget {
  final ValueNotifier<int> notifier;
  _LanguageOptions({Key key, this.notifier}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LanguageOptionsState();
}

class _LanguageOptionsState extends State<_LanguageOptions> {
  void change(int option) {
    setState(() {
      widget.notifier.value = option;
    });
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          tappableFlag('nl', 0),
          tappableFlag('en', 1),
          tappableFlag('hu', 2),
        ],
      );

  Widget tappableFlag(String country, int value) => Padding(
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        child: GestureDetector(
          onTap: () {
            change(value);
          },
          child: Opacity(
            opacity: widget.notifier.value == value ? 1.0 : 0.3,
            child: Image.asset(
              'assets/lang/' + country + '/flag40.png',
              width: 40.0,
            ),
          ),
        ),
      );
}
