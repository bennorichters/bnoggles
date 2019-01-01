// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/gamelogic/game.dart';
import 'package:bnoggles/utils/gamelogic/lettter_sequence.dart';

void main() {
  test('ensure solution with one word', () {
    Game game = Game(
        3,
        FakeLetterGenerator(),
        Dictionary([
          '12345',
        ]),
        2);

    expect(game.board.width, 3);
    expect(game.solution.uniqueWords().contains('12345'), true);
  });
}

class FakeLetterGenerator implements SequenceGenerator {
  @override
  String next() => 'a';

  @override
  void decreaseLength() => throw UnsupportedError;
}
