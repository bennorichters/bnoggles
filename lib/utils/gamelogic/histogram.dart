// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';
import 'package:collection/collection.dart';

const _eq = const MapEquality<int, int>();

class Histogram {
  final Map<int, int> _countPerLength;

  Histogram.fromStrings(Iterable<String> words)
      : this._(
          groupBy(
            words.where((word) => word.isNotEmpty).map((word) => word.length),
            (int wordLength) => wordLength,
          ).map(
            (wordLength, elements) => MapEntry(wordLength, elements.length),
          ),
        );

  Histogram._(this._countPerLength);

  int get longest => isEmpty ? 0 : _countPerLength.keys.reduce(max);

  bool get isEmpty => _countPerLength.isEmpty;

  int get count => atLeast(0);

  int operator [](int i) =>
      _countPerLength.containsKey(i) ? _countPerLength[i] : 0;

  int atLeast(int i) => _countPerLength.keys
      .where((k) => k >= i)
      .map((k) => _countPerLength[k])
      .fold(0, (a, b) => a + b);

  @override
  bool operator ==(dynamic other) =>
      other is Histogram && _eq.equals(_countPerLength, other._countPerLength);

  @override
  int get hashCode => _eq.hash(_countPerLength);

  @override
  String toString() => _countPerLength.toString();

  Histogram operator -(Histogram other) {
    Map<int, int> result = Map();
    for (int key in Set.from(_countPerLength.keys)
      ..addAll(other._countPerLength.keys)) {
      int diff = this[key] - other[key];
      if (diff < 0) throw ArgumentError('$this - $other < 0');
      if (diff > 0) result[key] = diff;
    }

    return Histogram._(result);
  }
}
