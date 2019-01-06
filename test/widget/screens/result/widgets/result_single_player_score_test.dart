// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/result/widgets/result_single_player_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helper.dart';

const Map<int, TableColumnWidth> _columnWidths = {
  0: FixedColumnWidth(50.0),
  1: FixedColumnWidth(50.0),
  2: FixedColumnWidth(100.0),
};

void main() {
  testWidgets('find numbers', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(
      child: ResultSinglePlayerScore(
        foundWords: 5,
        availableWordsCount: 10,
        score: 99,
        maxScore: 101,
        fontSize: 10,
        columnWidths: _columnWidths,
      ),
    ));

    expect(find.text('5'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('99'), findsOneWidget);
    expect(find.text('101'), findsOneWidget);
  });
}
