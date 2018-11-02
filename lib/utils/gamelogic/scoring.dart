// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/gamelogic/histogram.dart';

typedef int ScoreCalculator(Histogram available, Histogram found);

final ScoreCalculator standard = (available, found) {
  var maximumWordCount = available.count;
  if (maximumWordCount == 0) {
    return 0;
  }

  int result = 0;
  for (int i = 0; i < found.longest; i++) {
    result += i * 2 * found[i];
  }

  var percentageFound = (found.count / maximumWordCount);
  result = (result * percentageFound * percentageFound).round();
  result += found.count;

  return result;
};