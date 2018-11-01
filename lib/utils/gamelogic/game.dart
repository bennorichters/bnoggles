import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';

class Game {
  final Board board;
  final Solution solution;

  Game._(this.board, this.solution);

  factory Game(int boardSize, int minimalWordLength,
      RandomLetterGenerator generator, Dictionary dictionary) {
    Board board = Board(
      boardSize,
      generator,
    );

    Solution solution = Solution(
      board,
      dictionary,
      minimalWordLength,
    );

    if (solution.uniqueWords().length == 0) {
      String word = dictionary.randomWord(4);
      board = board.insertWordRandomly(word);

      solution = Solution(
        board,
        dictionary,
        minimalWordLength,
      );
    }

    return Game._(board, solution);
  }
}
