// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/preferences.dart';
import 'package:bnoggles/widgets/start_game_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ResultActionRow extends StatelessWidget {
  ResultActionRow({
    @required this.parameters,
  });
  final ParameterProvider parameters;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          heroTag: "settings",
          onPressed: () {
            Navigator.popUntil(
              context,
              ModalRoute.withName(Navigator.defaultRouteName),
            );
          },
          child: Icon(Icons.settings),
        ),
        Container(
          width: 20.0,
        ),
        StartGameButton(
          parameterProvider: parameters,
          replaceScreen: true,
        ),
      ],
    );
  }
}
