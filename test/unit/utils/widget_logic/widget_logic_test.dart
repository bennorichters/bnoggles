// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:bnoggles/utils/widget_logic/widget_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatTime', () {
    expect(formatTime(0), '0:00');
    expect(formatTime(1), '0:01');
    expect(formatTime(59), '0:59');
    expect(formatTime(60), '1:00');
    expect(formatTime(61), '1:01');
    expect(formatTime(599), '9:59');
    expect(formatTime(600), '10:00');
    expect(formatTime(601), '10:01');
    expect(formatTime(5999), '99:59');
    expect(formatTime(6000), '100:00');
    expect(formatTime(6001), '100:01');
  });

  test('interpolateY', () {
    expect(
        Interpolator.fromDataPoints(
          p1: Point(4, 20),
          p2: Point(6, 30),
        ).y(x: 5),
        25);

    expect(
        Interpolator.fromDataPoints(
          p1: Point(0, 0),
          p2: Point(10, 10),
        ).y(x: 5),
        5);

    expect(
        Interpolator.fromDataPoints(
          p1: Point(3, 3),
          p2: Point(6, 6),
        ).y(x: 5),
        5);

    expect(
        Interpolator.fromDataPoints(
          p1: Point(0, 0),
          p2: Point(10, 10),
          min: -1,
          max: 6,
        ).y(x: 5),
        5);

    expect(
        Interpolator.fromDataPoints(
          p1: Point(3, 3),
          p2: Point(6, 6),
          min: -1,
          max: 6,
        ).y(x: 5),
        5);

    expect(
        Interpolator.fromDataPoints(
          p1: Point(3, 3),
          p2: Point(6, 6),
          min: 6,
        ).y(x: 6),
        6);

    expect(
        Interpolator.fromDataPoints(
          p1: Point(3, 3),
          p2: Point(6, 6),
          max: 4,
        ).y(x: 4),
        4);
  });
}
