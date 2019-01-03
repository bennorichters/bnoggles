// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/result/widgets/result_single_player_score.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helper.dart';

void main() {
  testWidgets('find numbers', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(
      child: ResultSinglePlayerScore(
        maxScore: 10,
        score: 5,
        fontSize: 10,
      ),
    ));

    expect(find.text('5'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });
}
