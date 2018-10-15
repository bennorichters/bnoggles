import 'package:bnoggles/screens/result/result_screen.dart';
import 'package:bnoggles/utils/solution.dart';
import 'package:bnoggles/widgets/provider.dart';
import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  State createState() => _ClockState();
}

class _ClockState extends State<Clock> with TickerProviderStateMixin {
  AnimationController _controller;

  static const int _startValue = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _startValue),
    );

    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    var animation = StepTween(
            begin: _startValue,
            end: 0,
          ).animate(_controller);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Solution solution = Provider.immutableDataOf(context)["solution"];
        UserAnswer userAnswer = Provider.mutableDataOf(context).value;

        Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) =>
            ResultScreen(solution, userAnswer)));
      }
    });

    return Container(
      child: Center(
        child: Countdown(
          animation: animation,
        ),
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    return new Text(
      formatTime(animation.value),
      style: new TextStyle(fontSize: 30.0),
    );
  }

  formatTime(int seconds) {
    int minutes = (seconds / 60).floor();
    String restSeconds = (seconds - 60 * minutes).toString().padLeft(2, "0");
    return "$minutes:$restSeconds";
  }
}

