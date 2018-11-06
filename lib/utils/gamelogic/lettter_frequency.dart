// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

class LetterFrequencyInfo {
  final Map<int, Map<String, int>> _freqsPerLength;

  LetterFrequencyInfo._(this._freqsPerLength);

  factory LetterFrequencyInfo(Map<String, int> frequencies) {
    Map<int, Map<String, int>> freqsPerSize = {};
    for (MapEntry<String, int> entry in frequencies.entries) {
      int length = entry.key.length;
      freqsPerSize.putIfAbsent(length, () => {});
      freqsPerSize[length].addEntries([entry]);
    }

    return LetterFrequencyInfo._(freqsPerSize);
  }

  List<int> _lengths() => _freqsPerLength.keys.toList()..sort();

  List<String> _keys(int length) => _freqsPerLength.keys
      .where((key) => key == length)
      .map((length) => _freqsPerLength[length].keys.toList())
      .reduce((a, b) => a..addAll(b))
        ..sort();

  int _totalValue(int length) => _freqsPerLength.keys
      .where((key) => key == length)
      .map((length) => _freqsPerLength[length].values.reduce((a, b) => a + b))
      .reduce((a, b) => a + b);

  int _value(String key) => _freqsPerLength[key.length][key];
}

class LetterGenerator {
  final Random _rng;
  final List<int> _lengths;
  final LetterFrequencyInfo _info;

  int _totalValue;
  List<String> _keys;

  LetterGenerator._(
      this._lengths, this._info, this._totalValue, this._keys, this._rng);

  factory LetterGenerator(LetterFrequencyInfo info, [Random rnd]) {
    List<int> lengths = info._lengths();
    rnd ??= Random();

    return LetterGenerator._(
      lengths,
      info,
      info._totalValue(_lastValue(lengths)),
      info._keys(_lastValue(lengths)),
      rnd,
    );
  }

  static int _lastValue(List<int> list) => list[list.length - 1];

  String next() {
    var randomNumber = _rng.nextInt(_totalValue);

    var sum = 0;
    for (String c in _keys) {
      sum += _info._value(c);
      if (sum > randomNumber) return c;
    }

    throw StateError('should not reach this code');
  }

  void decreaseLength() {
    assert(_lengths.length > 1, "cannot decrease length anymore");
    _lengths.removeLast();

    _totalValue = _info._totalValue(_lastValue(_lengths));
    _keys = _info._keys(_lastValue(_lengths));
  }
}
