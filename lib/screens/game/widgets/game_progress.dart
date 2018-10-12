import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/game_word_count_row.dart';

class GameProgress extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 300.0, height: 130.0, child: WordCountOverview()),
          Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.black,
            width: 80.0,
            child: Center(
                child: Text('2:30',
                    style: TextStyle(fontSize: 30.0, color: Colors.white))),
          ),
        ]);
  }
}
