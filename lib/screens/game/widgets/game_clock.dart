import 'package:bnoggles/utils/helper/helper.dart';
import 'package:flutter/material.dart';

class Clock extends StatelessWidget {
  final VoidCallback showResultScreen;
  final AnimationController _controller;
  final int startTime;

  Clock(this.showResultScreen, this._controller, this.startTime);

  @override
  Widget build(BuildContext context) {
    var animation = StepTween(
      begin: startTime + 1,
      end: 1,
    ).animate(_controller);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        showResultScreen();
      }
    });

    return Countdown(animation: animation);
  }
}

class Countdown extends AnimatedWidget {
  final Animation<int> animation;
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: animation.value <= 30
          ? (animation.value <= 10 ? Colors.red : Colors.orange)
          : Colors.lightBlueAccent,
      child: Center(
        child: new Text(
          formatTime(animation.status == AnimationStatus.completed
              ? 0
              : animation.value),
          style: new TextStyle(
              fontSize: 30.0,
              color: animation.value <= 10 ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
