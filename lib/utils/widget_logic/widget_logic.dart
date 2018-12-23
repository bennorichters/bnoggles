// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math' as Math;

/// Returns a String representing the time in the format MM:SS
String formatTime(int seconds) {
  int minutes = (seconds / 60).floor();
  String restSeconds = (seconds - 60 * minutes).toString().padLeft(2, '0');
  return '$minutes:$restSeconds';
}

/// Interpolates data points to find value y for given x
double interpolateY(
    {double x,
    double smallX,
    double smallY,
    double bigX,
    double bigY,
    double min = double.negativeInfinity,
    double max = double.infinity}) {

  double a = (bigY - smallY) / (bigX - smallX);
  double b = smallY - (a * smallX);

  return Math.max(Math.min(a * x + b, max), min);
}
