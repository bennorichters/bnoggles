import 'package:flutter/widgets.dart';

import 'package:bnoggles/utils/board.dart';
import 'package:bnoggles/utils/solution.dart';

class GameInfo {
  final Board board;
  final Solution solution;
  final ValueNotifier<UserAnswer> userAnswer;
  bool gameOngoing;

  GameInfo(
      {this.board, this.solution, this.userAnswer, this.gameOngoing = true});

  void addListener(listener) {
    userAnswer.addListener(listener);
  }

  void removeListener(listener) {
    userAnswer.removeListener(listener);
  }
}

class Provider extends StatefulWidget {
  final GameInfo gameInfo;
  final child;

  const Provider({this.gameInfo, this.child});

  static GameInfo of(BuildContext context) {
    _InheritedProvider ip =
        context.inheritFromWidgetOfExactType(_InheritedProvider);
    return ip.gameInfo;
  }

  @override
  State<StatefulWidget> createState() => new _ProviderState();
}

class _ProviderState extends State<Provider> {
  @override
  initState() {
    super.initState();
    widget.gameInfo.addListener(didValueChange);
  }

  didValueChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return new _InheritedProvider(
      gameInfo: widget.gameInfo,
      child: widget.child,
    );
  }

  @override
  dispose() {
    widget.gameInfo.removeListener(didValueChange);
    super.dispose();
  }
}

class _InheritedProvider extends InheritedWidget {
  final GameInfo gameInfo;
  final child;
  final UserAnswer _userAnswerValue;

  _InheritedProvider({this.gameInfo, this.child})
      : _userAnswerValue = gameInfo.userAnswer.value,
        super(child: child);

  @override
  bool updateShouldNotify(_InheritedProvider oldWidget) {
    return _userAnswerValue != oldWidget._userAnswerValue;
  }
}
