// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:bnoggles/utils/widget_logic/widget_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/utils/gamelogic/answer.dart';

final _wordListHeightCalculator = Interpolator.fromDataPoints(
  p1: const Point(208, 30),
  p2: const Point(272, 48),
  min: 28,
  max: 60,
);

final _marginCalculator = Interpolator.fromDataPoints(
  p1: const Point(208, 2),
  p2: const Point(272, 4),
  min: 2,
  max: 6,
);

final _paddingCalculator = Interpolator.fromDataPoints(
  p1: const Point(208, 5),
  p2: const Point(272, 10),
  min: 4,
  max: 15,
);

final _fontSizeCalculator = Interpolator.fromDataPoints(
  p1: const Point(208, 10),
  p2: const Point(272, 20),
  min: 8,
  max: 30,
);

/// A list of words
///
/// The parent of this widget is responsible to call [setState] when the list
/// needs to be updated, e.g. by wrapping this widget in a
/// [ValueListenableBuilder].
class WordList extends StatefulWidget {
  WordList({
    @required this.words,
    @required this.scrollBackOnUpdate,
  });

  /// The words to be shown
  final List<WordDisplay> words;

  /// If [true] the list will scroll back to the start of the list when [words]
  /// are updated. No automatic scrolling will happen otherwise.
  final bool scrollBackOnUpdate;

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
  }

  @override
  void didUpdateWidget(WordList oldWidget) {
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
    MediaQueryData data = MediaQuery.of(context);
    double verticalSpaceLeft = data.size.height - data.size.width;

    return Container(
      height: _wordListHeightCalculator.y(x: verticalSpaceLeft),
      child: ListView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: widget.words
              .map((w) => _UserWordFeedback(w, verticalSpaceLeft))
              .toList()),
    );
  }
}

/// A container for a [String], a [Color] and a [TextStyle]
class WordDisplay {
  WordDisplay._(this._value, this._color, this._style);

  /// Creates an instance of [WordDisplay]. The color and style depend on the
  /// [UserWord.evaluation].
  WordDisplay.fromUser({
    @required UserWord userWord,
    @required double verticalSpaceLeft,
  }) : this._(
          userWord.word,
          _colors[userWord.evaluation],
          _createTextStyles(_fontSizeCalculator.y(
            x: verticalSpaceLeft,
          ))[userWord.evaluation],
        );

  /// Creates an instance of [WordDisplay] with a 'neutral' style.
  WordDisplay.neutral({
    @required String word,
    @required double verticalSpaceLeft,
  }) : this._(
          word,
          Colors.blue,
          createNeutralStyle(_fontSizeCalculator.y(
            x: verticalSpaceLeft,
          )),
        );

  final String _value;
  final Color _color;
  final TextStyle _style;

  @override
  String toString() => '$_value Color:$_color TextStyle:$_style';
}

Map<Evaluation, TextStyle> _createTextStyles(double fontSize) {
  return {
    Evaluation.good: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    ),
    Evaluation.wrong: TextStyle(
      fontSize: fontSize,
      decoration: TextDecoration.lineThrough,
    ),
    Evaluation.goodAgain: createNeutralStyle(fontSize),
  };
}

TextStyle createNeutralStyle(double fontSize) => TextStyle(fontSize: fontSize);

const Map<Evaluation, Color> _colors = {
  Evaluation.good: Colors.green,
  Evaluation.wrong: Colors.red,
  Evaluation.goodAgain: Colors.orange,
};

class _UserWordFeedback extends StatelessWidget {
  const _UserWordFeedback(this.word, this.verticalSpaceLeft);

  final WordDisplay word;
  final double verticalSpaceLeft;

  @override
  Widget build(BuildContext context) {
    double margin = _marginCalculator.y(x: verticalSpaceLeft);
    double padding = _paddingCalculator.y(x: verticalSpaceLeft);

    return Container(
      margin: EdgeInsets.all(margin),
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
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
