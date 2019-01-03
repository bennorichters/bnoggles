// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/game_screen.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter/material.dart';

/// Screen in which the player whose turn it is can start the game.
class PlayerScreen extends StatelessWidget {
  PlayerScreen({
    Key key,
    @required this.gameInfo,
  }) : super(key: key);

  final GameInfo gameInfo;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Bnoggles"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 100,
              ),
              Text(
                (gameInfo.currentPlayer + 1).toString(),
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              Container(height: 40,),
              FloatingActionButton(
                heroTag: 'startForPlayer',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (context) => GameScreen(
                            gameInfo: gameInfo,
                          ),
                    ),
                  );
                },
                child: Icon(Icons.play_arrow),
              ),
            ],
          ),
        ),
      );
}
