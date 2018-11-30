// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/format_time/format_time.dart';
import 'package:test/test.dart';

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
}