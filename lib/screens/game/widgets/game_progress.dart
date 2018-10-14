import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/game_clock.dart';
import 'package:bnoggles/screens/game/widgets/game_word_count_row.dart';

class GameProgress extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 300.0, height: 127.0, child: WordCountOverview()),
          Clock(),
        ]);
  }
}
