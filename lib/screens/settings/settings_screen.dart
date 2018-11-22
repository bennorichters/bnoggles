// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/settings/widgets/settings.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:bnoggles/widgets/start_game_button.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, @required this.preferences}) : super(key: key);

  final Preferences preferences;

  @override
  State createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Bnoggles"),
        ),
        body: Center(
          child: Container(
            width: 500.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SettingsGrid(widget.preferences),
                Center(
                  child: StartGameButton(
                    parameterProvider: widget.preferences.toParameters,
                    replaceScreen: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
