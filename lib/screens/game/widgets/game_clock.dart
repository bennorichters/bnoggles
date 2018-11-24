// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/helper/helper.dart';
import 'package:flutter/material.dart';

class Clock extends StatelessWidget {
  Clock(this.showResultScreen, this._controller, this.startTime);

  final VoidCallback showResultScreen;
  final AnimationController _controller;
  final int startTime;

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    double clockFontSize = data.size.width < 375.0 ? 15.0 : 30.0;

    var animation = StepTween(
      begin: startTime + 1,
      end: 1,
    ).animate(_controller);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        showResultScreen();
      }
    });

    return _Countdown(animation: animation, fontSize: clockFontSize);
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
                fontSize: fontSize,
                color: animation.value <= 10 ? Colors.white : Colors.black),
          ),
        ),
      );
}
