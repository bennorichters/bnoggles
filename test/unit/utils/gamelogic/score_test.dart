// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/gamelogic/frequency.dart';
import 'package:bnoggles/utils/gamelogic/score.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('calculate score', () {
    expect(calculateScore(Frequency.fromStrings([]), 1), 0);
    expect(calculateScore(Frequency.fromStrings(['ab']), 1), 9);
    expect(calculateScore(Frequency.fromStrings(['ab']), 2), 6);
    expect(calculateScore(Frequency.fromStrings(['ab']), 3), 5);
    expect(calculateScore(Frequency.fromStrings(['ab']), 4), 5);
    expect(calculateScore(Frequency.fromStrings(['ab']), 5), 4);
    expect(calculateScore(Frequency.fromStrings(['ab']), 6), 4);
    expect(calculateScore(Frequency.fromStrings(['ab']), 100), 4);

    expect(calculateScore(Frequency.fromStrings([]), 4), 0);
    expect(calculateScore(Frequency.fromStrings(['ab', 'abc', 'def']), 4), 38);
    expect(
        calculateScore(Frequency.fromStrings(['ab', 'abc', 'def', 'abcde']), 4),
        112);

    expect(calculateScore(Frequency.fromStrings([]), 7), 0);
    expect(calculateScore(Frequency.fromStrings(['ab']), 7), 4);
    expect(
        calculateScore(
            Frequency.fromStrings([
              'ab',
              'abc',
              'def',
              'abcde',
              '1234567890',
              '1234567890',
              '1234567890',
            ]),
            7),
        832);
  });
}
