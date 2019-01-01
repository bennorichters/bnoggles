// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

/// Information about the sequences of characters with which the [Board] is
/// filled.
///
/// The sole purpose of this class is to create a [SequenceGenerator] via the
/// method [createSequenceGenerator].
class LetterSequenceInfo {
  /// Creates a [LetterSequenceInfo].
  ///
  /// The given [frequencies] contains information that is letter used by the
  /// [SequenceGenerator]. The keys in this map are used to fill a [Board].
  /// The values determine the likelihood this key is chosen.
  factory LetterSequenceInfo(Map<String, int> frequencies) {
    Map<int, Map<String, int>> frequenciesPerLength = {};
    for (MapEntry<String, int> entry in frequencies.entries) {
      int length = entry.key.length;
      frequenciesPerLength.putIfAbsent(length, () => {});
      frequenciesPerLength[length].addEntries([entry]);
    }

    return LetterSequenceInfo._(frequenciesPerLength);
  }

  LetterSequenceInfo._(this._frequenciesPerLength);

  final Map<int, Map<String, int>> _frequenciesPerLength;

  /// Creates a SequenceGenerator.
  ///
  /// The given [random] is used to choose sequences. If this is omitted an
  /// instance of [Random] will be used.
  SequenceGenerator createSequenceGenerator([Random random]) {
    List<int> lengths = _lengths();
    random ??= Random();

    return SequenceGenerator._(
      lengths,
      this,
      _totalValue(lengths.last),
      _keys(lengths.last),
      random,
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

/// A generator for letter sequences to fill a [Board] with.
///
/// This generator chooses from the sequences that have been passed into the
/// constructor of [LetterSequenceInfo]. The method [SequenceGenerator.next]
/// generates sequences. When an instance of this class is first created,
/// calling next will generate a sequence that is chosen from the available
/// sequences that have the longest length. After calling
/// [SequenceGenerator.decreaseLength] the next method will choose from
/// sequences that have the one but highest length. Further calls to
/// decreaseLength will behave similarly until the shortest available length has
/// been reached.
///
/// Instances of this class are created with
/// [LetterSequenceInfo.createSequenceGenerator].
///
/// Instances of this class are mutable. For a new [Game], a new instance of
/// this class should be used.
class SequenceGenerator {
  SequenceGenerator._(
      this._lengths, this._info, this._totalValue, this._keys, this._random);

  final Random _random;
  final List<int> _lengths;
  final LetterSequenceInfo _info;

  int _totalValue;
  List<String> _keys;

  /// Generates a new letter sequence.
  ///
  /// For the exact behaviour of this method see the documentation at the class
  /// level.
  String next() {
    int randomNumber = _random.nextInt(_totalValue);

    int sum = 0;
    for (String sequence in _keys) {
      sum += _info._value(sequence);
      if (sum > randomNumber) return sequence;
    }

    throw StateError('should not reach this code');
  }

  /// Decreases the length of the sequences the method [SequenceGenerator.next]
  /// chooses from.
  ///
  /// For the exact behaviour of this method see the documentation at the class
  /// level.
  ///
  /// If the length cannot be decreased anymore, i.e. when the shortest
  /// available length has been reached already, this method will throw a
  /// [StateError].
  void decreaseLength() {
    if (_lengths.length < 2) throw StateError('cannot decrease length anymore');

    _lengths.removeLast();
    _totalValue = _info._totalValue(_lengths.last);
    _keys = _info._keys(_lengths.last);
  }
}
