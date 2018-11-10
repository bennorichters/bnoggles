// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

class LetterSequenceInfo {
  final Map<int, Map<String, int>> _frequenciesPerLength;

  LetterSequenceInfo._(this._frequenciesPerLength);

  factory LetterSequenceInfo(Map<String, int> frequencies) {
    Map<int, Map<String, int>> frequenciesPerLength = {};
    for (MapEntry<String, int> entry in frequencies.entries) {
      int length = entry.key.length;
      frequenciesPerLength.putIfAbsent(length, () => {});
      frequenciesPerLength[length].addEntries([entry]);
    }

    return LetterSequenceInfo._(frequenciesPerLength);
  }

  SequenceGenerator createSequenceGenerator([Random rnd]) {
    List<int> lengths = _lengths();
    rnd ??= Random();

    return SequenceGenerator._(
      lengths,
      this,
      _totalValue(lengths.last),
      _keys(lengths.last),
      rnd,
    );
  }

  List<int> _lengths() => _frequenciesPerLength.keys.toList()..sort();

  List<String> _keys(int length) => _frequenciesPerLength.keys
      .where((key) => key == length)
      .map((length) => _frequenciesPerLength[length].keys.toList())
      .reduce((a, b) => a..addAll(b))
        ..sort();

  int _totalValue(int length) => _frequenciesPerLength.keys
      .where((key) => key == length)
      .map((length) =>
          _frequenciesPerLength[length].values.reduce((a, b) => a + b))
      .reduce((a, b) => a + b);

  int _value(String key) => _frequenciesPerLength[key.length][key];
}

class SequenceGenerator {
  final Random _rng;
  final List<int> _lengths;
  final LetterSequenceInfo _info;

  int _totalValue;
  List<String> _keys;

  SequenceGenerator._(
      this._lengths, this._info, this._totalValue, this._keys, this._rng);

  String next() {
    int randomNumber = _rng.nextInt(_totalValue);

    int sum = 0;
    for (String sequence in _keys) {
      sum += _info._value(sequence);
      if (sum > randomNumber) return sequence;
    }

    throw StateError('should not reach this code');
  }

  void decreaseLength() {
    if (_lengths.length < 2) throw StateError("cannot decrease length anymore");

    _lengths.removeLast();
    _totalValue = _info._totalValue(_lengths.last);
    _keys = _info._keys(_lengths.last);
  }
}
