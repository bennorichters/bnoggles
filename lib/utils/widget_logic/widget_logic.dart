// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math' as Math;

/// Returns a String representing the time in the format mm:ss, where m stands
/// for minute and s for second.
String formatTime(int seconds) {
  int minutes = (seconds / 60).floor();
  String restSeconds = (seconds - 60 * minutes).toString().padLeft(2, '0');
  return '$minutes:$restSeconds';
}

/// Calculator that finds y for a given value x based on two linear data points.
///
/// This class can typically be used to calculate different dimensions for
/// widgets based on the screen size.
class Interpolator {
  factory Interpolator.fromDataPoints({
    Math.Point p1,
    Math.Point p2,
    double min = double.negativeInfinity,
    double max = double.infinity,
  }) {
    double a = (p1.y - p2.y) / (p1.x - p2.x);
    double b = p1.y - (a * p1.x);

    return Interpolator._(a, b, min, max);
  }

  const Interpolator._(
    this._a,
    this._b,
    this._min,
    this._max,
  );

  final double _a;
  final double _b;
  final double _min;
  final double _max;

  /// Calculates the value for y
  double y({double x}) => Math.max(Math.min(_a * x + _b, _max), _min);
}
