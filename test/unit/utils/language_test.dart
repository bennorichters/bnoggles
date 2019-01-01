// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/game.dart';
import 'package:bnoggles/utils/language.dart';

void main() {
  test('create game', () async {
    Map<String, String> frequencies = {
      'abc': '{"a": 1, "b": 1, "c": 1}',
      'def': '{"d": 1, "e": 1, "f": 1}',
    };

    Map<String, String> words = {
      'abc': 'ab\nac\nbc\ncbabc',
      'def': 'defde',
    };

    var loader = LanguageLoader(
      characterSequenceFrequencies: (c) => Future<String>.value(frequencies[c]),
      availableWords: (c) => Future<String>.value(words[c]),
    );

    Language.registerLoader(loader);
    Language language;
    Game game;

    language = await Language.forLanguageCode('abc');
    game = language.createGame(3, 2);
    testForAllowedLetters(game, ['a', 'b', 'c']);

    language = await Language.forLanguageCode('def');
    game = language.createGame(3, 2);
    testForAllowedLetters(game, ['d', 'e', 'f']);
  });
}

void testForAllowedLetters(Game game, List<String> allowed) {
  expect(game.board.width, 3);
  for (int x = 0; x < 3; x++) {
    for (int y = 0; y < 3; y++) {
      expect(game.board[Coordinate(x, y)], anyOf(allowed));
    }
  }
}
