// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// Creates a list of three widgets; an [Icon], a [Container] and a [Row] that
/// in turn contains three images.
///
/// The three images represent the flags of the UK, Holland and Hungary. The
/// user can change the value of [notifier] by tapping on the flags.
List<Widget> languageOptions({
  @required ValueNotifier<int> notifier,
  @required Icon icon,
}) =>
    [
      icon,
      Container(),
      _LanguageOptions(notifier: notifier),
    ];

class _LanguageOptions extends StatefulWidget {
  _LanguageOptions({Key key, this.notifier}) : super(key: key);
  final ValueNotifier<int> notifier;

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
          key: Key('LSGD_' + country),
          onTap: () {
            change(value);
          },
          child: Opacity(
            opacity: widget.notifier.value == value ? 1.0 : 0.3,
            child: Image.asset(
              'assets/lang/' + country + '/flag40.png',
              width: 40.0,
              height: 40.0,
            ),
          ),
        ),
      );
}
