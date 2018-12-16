// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter/widgets.dart';

import 'package:bnoggles/utils/gamelogic/solution.dart';

/// A widget that holds an instance of [GameInfo] that is accessible by its
/// descendants.
class Provider extends StatefulWidget {
  /// Creates a [Provider]. The given [gameInfo] is accessible by [child] and
  /// the children of child.
  const Provider({this.gameInfo, this.child});

  final GameInfo gameInfo;
  final Widget child;

  /// Returns the instance of [GameInfo] hold by this provider.
  static GameInfo of(BuildContext context) {
    _InheritedProvider ip =
        context.inheritFromWidgetOfExactType(_InheritedProvider);
    return ip.gameInfo;
  }

  @override
  State<StatefulWidget> createState() => _ProviderState();
}

class _ProviderState extends State<Provider> {
  @override
  void initState() {
    super.initState();
    widget.gameInfo.addUserAnswerListener(didValueChange);
  }

  void didValueChange() => setState(() {});

  @override
  Widget build(BuildContext context) => _InheritedProvider(
        gameInfo: widget.gameInfo,
        child: widget.child,
      );

  @override
  void dispose() {
    widget.gameInfo.removeUserAnswerListener(didValueChange);
    super.dispose();
  }
}

class _InheritedProvider extends InheritedWidget {
  _InheritedProvider({this.gameInfo, Widget child})
      : userAnswerValue = gameInfo.userAnswer.value,
        super(child: child);

  final GameInfo gameInfo;
  final UserAnswer userAnswerValue;

  @override
  bool updateShouldNotify(_InheritedProvider oldWidget) =>
      userAnswerValue != oldWidget.userAnswerValue;
}
