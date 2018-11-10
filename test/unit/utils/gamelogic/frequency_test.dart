// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/gamelogic/frequency.dart';
import 'package:test/test.dart';

void main() {
  test('emptyList', () {
    Frequency d = Frequency.fromStrings([]);
    expect(d.longest, 0);
    expect(d[0], 0);
    expect(d.atLeast(0), 0);
    expect(d.isEmpty, true);
  });

  test('emptyString', () {
    Frequency d = Frequency.fromStrings(['']);
    expect(d.longest, 0);
    expect(d[0], 0);
    expect(d.atLeast(0), 0);
    expect(d.isEmpty, true);
  });

  test('singleLetter', () {
    Frequency d = Frequency.fromStrings(['a']);
    expect(d.longest, 1);
    expect(d[0], 0);
    expect(d[1], 1);
    expect(d[2], 0);
    expect(d.atLeast(0), 1);
    expect(d.atLeast(1), 1);
    expect(d.atLeast(2), 0);
    expect(d.isEmpty, false);
  });

  test('isEmpty', () {
    expect(Frequency.fromStrings([]).isEmpty, true);
    expect(Frequency.fromStrings(['']).isEmpty, true);
    expect(Frequency.fromStrings(['a']).isEmpty, false);
  });

  test('atLeast', () {
    expect(Frequency.fromStrings(['a']).atLeast(0), 1);
    expect(Frequency.fromStrings(['a']).atLeast(1), 1);
    expect(Frequency.fromStrings(['a']).atLeast(2), 0);
    expect(Frequency.fromStrings(['a', 'aaa', 'aaa']).atLeast(0), 3);
    expect(Frequency.fromStrings(['a', 'aaa', 'aaa']).atLeast(1), 3);
    expect(Frequency.fromStrings(['a', 'aaa', 'aaa']).atLeast(2), 2);
    expect(Frequency.fromStrings(['a', 'aaa', 'aaa']).atLeast(3), 2);
    expect(Frequency.fromStrings(['a', 'aaa', 'aaa']).atLeast(4), 0);
  });

  test('longest', () {
    expect(Frequency.fromStrings(['']).longest, 0);
    expect(Frequency.fromStrings(['a']).longest, 1);
    expect(Frequency.fromStrings(['a', 'aaa']).longest, 3);
    expect(Frequency.fromStrings(['a', 'aaa', 'aaa']).longest, 3);
  });

  test('equals', () {
    var d = Frequency.fromStrings([]);
    expect(d == d, true);
    expect(Frequency.fromStrings(['']) == Frequency.fromStrings([]), true);
    expect(Frequency.fromStrings(['a']) == Frequency.fromStrings(['a']), true);
    expect(Frequency.fromStrings(['a']) == Frequency.fromStrings(['b']), true);
    expect(
        Frequency.fromStrings(['a', 'aaa']) ==
            Frequency.fromStrings(['aaa', 'a']),
        true);
    expect(Frequency.fromStrings(['a']) == Frequency.fromStrings(['aaa', 'a']),
        false);
  });

  test('hashCode', () {
    var d = Frequency.fromStrings([]);
    expect(d.hashCode == d.hashCode, true);
    expect(
        Frequency.fromStrings(['']).hashCode ==
            Frequency.fromStrings([]).hashCode,
        true);
    expect(
        Frequency.fromStrings(['a']).hashCode ==
            Frequency.fromStrings(['a']).hashCode,
        true);
    expect(
        Frequency.fromStrings(['a']).hashCode ==
            Frequency.fromStrings(['b']).hashCode,
        true);
    expect(
        Frequency.fromStrings(['a', 'aaa']).hashCode ==
            Frequency.fromStrings(['aaa', 'a']).hashCode,
        true);
    expect(
        Frequency.fromStrings(['a']).hashCode ==
            Frequency.fromStrings(['aaa', 'a']).hashCode,
        false);
  });

  test('minus', () {
    expect(Frequency.fromStrings(['a']) - Frequency.fromStrings(['a']),
        Frequency.fromStrings([]));
    expect(Frequency.fromStrings(['a']) - Frequency.fromStrings(['']),
        Frequency.fromStrings(['a']));
    expect(Frequency.fromStrings(['a', 'aaa']) - Frequency.fromStrings(['a']),
        Frequency.fromStrings(['aaa']));
    expect(() => Frequency.fromStrings(['aaa']) - Frequency.fromStrings(['a']),
        throwsArgumentError);
    expect(
        () => Frequency.fromStrings(['a']) - Frequency.fromStrings(['a', 'a']),
        throwsArgumentError);
  });
}
