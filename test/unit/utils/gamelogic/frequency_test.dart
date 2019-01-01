// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:bnoggles/utils/gamelogic/frequency.dart';

void main() {
  test('emptyList', () {
    Frequency f = Frequency.fromStrings([]);
    expect(f.longest, 0);
    expect(f[0], 0);
    expect(f.atLeast(0), 0);
    expect(f.isEmpty, true);
  });

  test('emptyString', () {
    Frequency f = Frequency.fromStrings(['']);
    expect(f.longest, 0);
    expect(f[0], 0);
    expect(f.atLeast(0), 0);
    expect(f.isEmpty, true);
  });

  test('singleLetter', () {
    Frequency f = Frequency.fromStrings(['a']);
    expect(f.longest, 1);
    expect(f[0], 0);
    expect(f[1], 1);
    expect(f[2], 0);
    expect(f.atLeast(0), 1);
    expect(f.atLeast(1), 1);
    expect(f.atLeast(2), 0);
    expect(f.isEmpty, false);
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
    var f = Frequency.fromStrings([]);
    expect(f == f, true);
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
    var f = Frequency.fromStrings([]);
    expect(f.hashCode == f.hashCode, true);
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
