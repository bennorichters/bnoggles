// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/utils/gamelogic/solution.dart';

/// A list of words
///
/// The parent of this widget is responsible to call [setState] when the list
/// needs to be updated, e.g. by wrapping this widget in a
/// [ValueListenableBuilder].
class WordWindow extends StatefulWidget {
  WordWindow({
    @required this.words,
    @required this.scrollBackOnUpdate,
  });

  /// The words to be shown
  final List<WordDisplay> words;
  /// If [true] the list will scroll back to the start of the list when [words]
  /// are updated. No automatic scrolling will happen otherwise.
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

/// A container for a [String], a [Color] and a [TextStyle]
class WordDisplay {
  WordDisplay._(this._value, this._color, this._style);

  /// Creates an instance of [WordDisplay]. The color and style depend on the
  /// [UserWord.evaluation].
  WordDisplay.fromUser(UserWord userWord)
      : this._(
          userWord.word,
          _colors[userWord.evaluation],
          _textStyle[userWord.evaluation],
        );

  /// Creats an instance of [WordDisplay] with a 'neutral' style.
  WordDisplay.neutral(String word)
      : this._(
          word,
          Colors.blue,
          _neutralStyle,
        );

  final String _value;
  final Color _color;
  final TextStyle _style;

  @override
  String toString() => '$_value Color:$_color TextStyle:$_style';
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
  final WordDisplay word;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: word._color,
      ),
      child: Center(
        child: Text(
          word._value.toUpperCase(),
          style: word._style,
        ),
      ),
    );
  }
}
