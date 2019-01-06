// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/widget_logic/widget_logic.dart';
import 'package:flutter/material.dart';

/// Widget showing a clock that counts down to zero.
class Clock extends StatelessWidget {
  /// Creates the [Clock]
  Clock({
    @required this.timeOutAction,
    @required this.controller,
    @required this.startTime,
    @required this.fontSize,
  });

  final VoidCallback timeOutAction;
  final AnimationController controller;
  final int startTime;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    Animation<int> animation = StepTween(
      begin: startTime + 1,
      end: 1,
    ).animate(controller);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        timeOutAction();
      }
    });

    return _Countdown(
      animation: animation,
      fontSize: fontSize,
    );
  }
}

class _Countdown extends AnimatedWidget {
  _Countdown({Key key, this.animation, this.fontSize})
      : super(key: key, listenable: animation);

  final Animation<int> animation;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Container(
        color: animation.value <= 30
            ? (animation.value <= 10 ? Colors.red : Colors.orange)
            : Colors.lightBlueAccent,
        child: Center(
          child: Text(
            formatTime(animation.status == AnimationStatus.completed
                ? 0
                : animation.value),
            style: TextStyle(
                fontFamily: 'Inconsolata',
                fontSize: fontSize,
                color: animation.value <= 10 ? Colors.white : Colors.black),
          ),
        ),
      );
}
