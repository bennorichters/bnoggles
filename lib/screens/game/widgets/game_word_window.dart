import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/provider.dart';

import 'package:bnoggles/utils/gamelogic/solution.dart';

class WordWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserAnswer userAnswer = Provider.of(context).userAnswer.value;

    return Container(
        height: 50.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: userAnswer.found.reversed
              .map((a) => _UserWordFeedback(a))
              .toList(),
        ));
  }
}

class _UserWordFeedback extends StatelessWidget {
  static const Map<Evaluation, Color> _colors = {
    Evaluation.good: Colors.green,
    Evaluation.wrong: Colors.red,
    Evaluation.goodAgain: Colors.orange
  };

  final UserWord _userWord;
  _UserWordFeedback(this._userWord);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 5.0),
        padding: new EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: _colors[_userWord.eval],
        ),
        child: Center(
            child: Text(_userWord.word.toUpperCase(),
                style: TextStyle(
                  fontSize: 20.0,
                ))));
  }
}
