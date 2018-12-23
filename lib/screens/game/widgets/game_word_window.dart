// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/utils/gamelogic/solution.dart';

class WordWindow extends StatefulWidget {
  WordWindow({
    @required this.words,
    @required this.scrollBackOnUpdate,
  });

  final List<Word> words;
  final bool scrollBackOnUpdate;

  @override
  State<WordWindow> createState() => _WordWindowState();
}

class _WordWindowState extends State<WordWindow> {
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
  }

  @override
  void didUpdateWidget(WordWindow oldWidget) {
    if (widget.scrollBackOnUpdate) {
      controller.animateTo(
        controller.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      child: ListView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: widget.words.map((w) => _UserWordFeedback(w)).toList()),
    );
  }
}

class Word {
  Word._(this.value, this.color, this.style);

  Word.fromUser(UserWord userWord)
      : this._(
          userWord.word,
          _colors[userWord.evaluation],
          _textStyle[userWord.evaluation],
        );

  Word.neutral(String word)
      : this._(
          word,
          Colors.blue,
          _neutralStyle,
        );

  final String value;
  final Color color;
  final TextStyle style;

  @override
  String toString() => '$value Color:$color TextStyle:$style';
}

const double _fontSize = 20.0;

const _neutralStyle = TextStyle(
  fontSize: _fontSize,
);

const Map<Evaluation, TextStyle> _textStyle = {
  Evaluation.good: TextStyle(
    fontSize: _fontSize,
    fontWeight: FontWeight.bold,
  ),
  Evaluation.wrong: TextStyle(
    fontSize: _fontSize,
    decoration: TextDecoration.lineThrough,
  ),
  Evaluation.goodAgain: _neutralStyle,
};

const Map<Evaluation, Color> _colors = {
  Evaluation.good: Colors.green,
  Evaluation.wrong: Colors.red,
  Evaluation.goodAgain: Colors.orange,
};

class _UserWordFeedback extends StatelessWidget {
  const _UserWordFeedback(this.word);
  final Word word;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: word.color,
      ),
      child: Center(
        child: Text(
          word.value.toUpperCase(),
          style: word.style,
        ),
      ),
    );
  }
}
