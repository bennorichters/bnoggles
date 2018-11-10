import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/gamelogic/game.dart';
import 'package:test/test.dart';

import 'package:bnoggles/utils/gamelogic/lettter_sequence.dart';

void main() {
  test('ensure solution with one word', () {
    Game game = Game(3, FakeLetterGenerator(), Dictionary(['bbbb']), 2);

    expect(game.board.width, 3);
    expect(game.solution.uniqueWords().contains('bbbb'), true);
  });
}

class FakeLetterGenerator implements SequenceGenerator {
  @override
  String next() => 'a';

  @override
  void decreaseLength() => throw UnsupportedError;
}