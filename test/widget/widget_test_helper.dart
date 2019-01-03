// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:bnoggles/screens/game/widgets/game_info_provider.dart';
import 'package:bnoggles/utils/game_info.dart';

import '../test_helper.dart';

Widget testableRow({List<Widget> children}) => MaterialApp(
      home: Material(
        child: Row(
          children: children,
        ),
      ),
    );

Widget testableWidget({Widget child}) => MaterialApp(
      home: Material(
        child: child,
      ),
    );

Widget testableConstrainedWidget({Widget child, double width, double height}) =>
    testableWidgetWithMediaQuery(
      child: Center(
        child: Container(
          width: width,
          height: height,
          child: UnconstrainedBox(
            child: child,
          ),
        ),
      ),
      width: width,
      height: height,
    );

Widget testableWidgetWithMediaQuery(
        {Widget child, double width, double height}) =>
    MaterialApp(
      home: Material(
        child: MediaQuery(
          data: MediaQueryData.fromWindow(ui.window).copyWith(
            size: Size(width, height),
          ),
          child: child,
        ),
      ),
    );

Widget testableWidgetWithProvider({Widget child, GameInfo info}) {
  return testableWidget(
    child: GameInfoProvider(
      gameInfo: info ?? createGameInfo(),
      child: child,
    ),
  );
}
