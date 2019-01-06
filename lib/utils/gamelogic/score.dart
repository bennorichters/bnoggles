// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/gamelogic/frequency.dart';

/// Calculates a score based on the words found and the total number of words
/// available.
int calculateScore(Frequency found, int allWordsCount) {
  int score = 0;
  for (int i = 2; i <= found.longest; i++) {
    score += found[i] * i * i;
  }

  score ~/= (1 / (1 + (found.count / allWordsCount)));

  if (found.count == allWordsCount) {
    score += (score ~/ 5);
  }

  return score;
}
