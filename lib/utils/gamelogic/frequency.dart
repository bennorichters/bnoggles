// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';
import 'package:collection/collection.dart';

const _eq = const MapEquality<int, int>();

/// A frequency to map the number of words per word length.
///
/// Two frequencies are considered equal if and only if for each word length
/// they have the same count.
class Frequency {
  /// Creates a [Frequency] based on the lengths of the given [words].
  Frequency.fromStrings(Iterable<String> words)
      : this._(
          groupBy(
            words.where((word) => word.isNotEmpty).map((word) => word.length),
            (int wordLength) => wordLength,
          ).map(
            (wordLength, elements) => MapEntry(wordLength, elements.length),
          ),
        );

  Frequency._(this._countPerLength);

  final Map<int, int> _countPerLength;

  /// The longest word length which count is greater than zero
  int get longest => isEmpty ? 0 : _countPerLength.keys.reduce(max);

  /// Returns [true] if for all word lengths this [Frequency] will return zero,
  /// [false] otherwise.
  bool get isEmpty => _countPerLength.isEmpty;

  /// The total number of words
  int get count => atLeast(0);

  /// Returns the count for the given [length]
  int operator [](int length) =>
      _countPerLength.containsKey(length) ? _countPerLength[length] : 0;

  /// Returns the total number of words which length is greater than or equal
  /// to the given [length].
  int atLeast(int length) => _countPerLength.keys
      .where((k) => k >= length)
      .map((k) => _countPerLength[k])
      .fold(0, (a, b) => a + b);

  @override
  bool operator ==(dynamic other) =>
      other is Frequency && _eq.equals(_countPerLength, other._countPerLength);

  @override
  int get hashCode => _eq.hash(_countPerLength);

  @override
  String toString() => _countPerLength.toString();

  /// Subtracts [other] from this [Frequency] and returns a new instance.
  ///
  /// The Frequency that is returned contains a count per word length that
  /// equals the count in [other] subtracted from the count in this.
  ///
  /// For each word length the count in [other] should be equal to or smaller
  /// than the count in this frequency. An [ArgumentError] will be thrown
  /// otherwise.
  Frequency operator -(Frequency other) {
    Map<int, int> result = Map();
    for (int key in Set.from(_countPerLength.keys)
      ..addAll(other._countPerLength.keys)) {
      int diff = this[key] - other[key];
      if (diff < 0) throw ArgumentError('$this - $other < 0');
      if (diff > 0) result[key] = diff;
    }

    return Frequency._(result);
  }
}
