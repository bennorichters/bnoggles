// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:bnoggles/utils/gamelogic/lettter_sequence.dart';

void main() {
  test('1 char', () {
    Map<String, int> freq = {
      'a': 1,
    };

    var info = LetterSequenceInfo(freq);
    var gen = info.createSequenceGenerator(MyRandom());

    expect(gen.next(), 'a');
    expect(gen.next(), 'a');
    expect(gen.next(), 'a');
  });

  test('3 -> 2 -> 1', () {
    Map<String, int> freq = {
      'abc': 1,
      'de': 1,
      'f': 1,
    };

    var info = LetterSequenceInfo(freq);
    var gen = info.createSequenceGenerator(MyRandom());

    expect(gen.next(), 'abc');
    expect(gen.next(), 'abc');
    expect(gen.next(), 'abc');

    gen.decreaseLength();

    expect(gen.next(), 'de');
    expect(gen.next(), 'de');
    expect(gen.next(), 'de');

    gen.decreaseLength();

    expect(gen.next(), 'f');
    expect(gen.next(), 'f');
    expect(gen.next(), 'f');
  });

  test('5 -> 3 -> 1', () {
    Map<String, int> freq = {
      'abcde': 1,
      'fgh': 1,
      'i': 1,
    };

    var info = LetterSequenceInfo(freq);
    var gen = info.createSequenceGenerator(MyRandom());

    expect(gen.next(), 'abcde');
    expect(gen.next(), 'abcde');
    expect(gen.next(), 'abcde');

    gen.decreaseLength();

    expect(gen.next(), 'fgh');
    expect(gen.next(), 'fgh');
    expect(gen.next(), 'fgh');

    gen.decreaseLength();

    expect(gen.next(), 'i');
    expect(gen.next(), 'i');
    expect(gen.next(), 'i');
  });

  test('5 -> 3 -> 1 multiple entries per length', () {
    Map<String, int> freq = {
      'abcde': 1,
      'ABCDE': 1,
      '12345': 1,
      'fgh': 1,
      'FGH': 1,
      'i': 1,
      'I': 1,
      '1': 1,
      '2': 1,
      '3': 1,
      '4': 1,
    };

    var info = LetterSequenceInfo(freq);
    var gen = info.createSequenceGenerator(MyRandom());

    expect(gen.next().length, 5);
    expect(gen.next().length, 5);
    expect(gen.next().length, 5);
    expect(gen.next().length, 5);
    expect(gen.next().length, 5);

    gen.decreaseLength();

    expect(gen.next().length, 3);
    expect(gen.next().length, 3);
    expect(gen.next().length, 3);
    expect(gen.next().length, 3);
    expect(gen.next().length, 3);

    gen.decreaseLength();

    expect(gen.next().length, 1);
    expect(gen.next().length, 1);
    expect(gen.next().length, 1);
    expect(gen.next().length, 1);
    expect(gen.next().length, 1);
  });

  test('bad random generator throws state error', () {
    Map<String, int> freq = {
      'a': 1,
    };

    var info = LetterSequenceInfo(freq);
    var gen = info.createSequenceGenerator(BadRandom());

    expect(() => gen.next(), throwsStateError);
  });
}

class MyRandom implements Random {
  int count = 0;

  @override
  bool nextBool() => throw UnsupportedError('only nextInt implemented');

  @override
  double nextDouble() => throw UnsupportedError('only nextInt implemented');

  @override
  int nextInt(int max) {
    count++;
    return count % max;
  }
}

class BadRandom implements Random {
  @override
  bool nextBool() => throw UnsupportedError('only nextInt implemented');

  @override
  double nextDouble() => throw UnsupportedError('only nextInt implemented');

  @override
  int nextInt(int max) {
    return max;
  }
}
