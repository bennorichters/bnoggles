// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/preferences.dart';
import 'package:bnoggles/widgets/start_game_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Row with two buttons, one to play again and one to go to the settings screen
class ResultActionRow extends StatelessWidget {
  /// Creates an instance of [ResultActionRow]
  ResultActionRow({
    @required this.parameters,
  });

  final ParameterProvider parameters;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            heroTag: 'settings',
            onPressed: () {
              Navigator.popUntil(
                context,
                ModalRoute.withName(Navigator.defaultRouteName),
              );
            },
            child: const Icon(Icons.settings),
          ),
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
