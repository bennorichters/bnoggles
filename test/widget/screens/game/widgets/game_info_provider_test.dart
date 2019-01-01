// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/game/widgets/game_info_provider.dart';
import 'package:bnoggles/utils/game_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helper.dart';

void main() {
  testWidgets('child of provider responds ot change',
      (WidgetTester tester) async {
    GameInfo info = createGameInfo();

    var text = TestWidget();

    GameInfoProvider provider = GameInfoProvider(
      gameInfo: info,
      child: text,
    );

    Widget w = testableWidget(child: provider);
    await tester.pumpWidget(w);

    var label0 = find.text('0');
    expect(label0, findsOneWidget);

    var vua = info.userAnswer;
    var nextAnswer = vua.value.add('abc', true);
    vua.value = nextAnswer;

    await tester.pumpAndSettle();

    var label1 = find.text('1');
    expect(label1, findsOneWidget);
  });
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gameInfo = GameInfoProvider.of(context);
    var answer = gameInfo.userAnswer;
    return Text(answer.value.uniqueWords().length.toString());
  }
}
