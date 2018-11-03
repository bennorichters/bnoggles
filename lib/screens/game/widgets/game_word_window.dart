// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/utils/gamelogic/solution.dart';

class WordWindow extends StatefulWidget {
  final WordsProvider provider;
  final ValueNotifier stateNotifier;

  WordWindow(this.provider, this.stateNotifier);

  @override
  State<WordWindow> createState() => WordWindowState();
}

class WordWindowState extends State<WordWindow> {
  @override
  void initState() {
    super.initState();
    widget.stateNotifier.addListener(_didValueChange);
  }

  void _didValueChange() => setState(() {});

  @override
  Widget build(BuildContext context) => Container(
        height: 48.0,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children:
                widget.provider().map((w) => _UserWordFeedback(w)).toList()),
      );

  @override
  void dispose() {
    widget.stateNotifier.removeListener(_didValueChange);
    super.dispose();
  }
}

typedef List<Word> WordsProvider();

class Word {
  final String value;
  final Color color;

  Word._(this.value, this.color);

  Word.fromUser(UserWord userWord)
      : this._(userWord.word, _colors[userWord.eval]);

  Word.neutral(String word) : this._(word, Colors.blue);
}

const Map<Evaluation, Color> _colors = {
  Evaluation.good: Colors.green,
  Evaluation.wrong: Colors.red,
  Evaluation.goodAgain: Colors.orange
};

class _UserWordFeedback extends StatelessWidget {
  final Word _word;
  _UserWordFeedback(this._word);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: _word.color,
      ),
      child: Center(
        child: Text(
          _word.value.toUpperCase(),
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
