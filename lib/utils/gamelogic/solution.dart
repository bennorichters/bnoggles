// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/gamelogic/frequency.dart';

/// An answer in the game.
///
/// An answer contains words that have been found on a [Board]. Found words are
/// considered to be correct, i.e. the board indeed contains that word and it
/// is valid according to the used [Dictionary].
abstract class Answer {
  Answer(this.frequency);

  /// Returns a [Frequency] with information about the number of words per word
  /// length.
  final Frequency frequency;

  /// A set of all unique and correct words that have been found.
  Set<String> uniqueWords();

  /// Returns [true] of this word is correct and has been found, [false]
  /// otherwise.
  bool contains(String word) => uniqueWords().contains(word);
}

/// An evaluation about a word that has been found on the board.
enum Evaluation {
  /// This word can indeed be found on the [Board] and is valid according to the
  /// used [Dictionary].
  good,

  /// This word is either not on the [Board] or is not valid according to the
  /// used [Dictionary].
  wrong,

  /// This word is good, but has been found already.
  goodAgain,
}

/// An sequence of characters as found by a player of the game.
class UserWord {
  /// Creates a [UserWord]
  UserWord(this.word, this.evaluation);

  /// The sequence of characters
  final String word;

  /// The evaluation of this word
  final Evaluation evaluation;

  @override
  String toString() => "$word - $evaluation";
}

/// An [Answer] is produced by a player of the game.
class UserAnswer extends Answer {
  /// Creates a new [UserAnswer] based on an old answer.
  ///
  /// The new UserAnswer is a copy of the old answer and is extended with the
  /// information provided by [word] and [isCorrect].
  factory UserAnswer(UserAnswer old, String word, bool isCorrect) {
    Evaluation eval;

    if (isCorrect && old.contains(word)) {
      eval = Evaluation.goodAgain;
    } else if (isCorrect) {
      eval = Evaluation.good;
    } else {
      eval = Evaluation.wrong;
    }

    return UserAnswer._(
      List.unmodifiable(old.found.toList()..add(UserWord(word, eval))),
    );
  }

  UserAnswer._(List<UserWord> found)
      : this.found = found,
        super(Frequency.fromStrings(_uniqueWords(found)));

  /// All words found by the user in the order that they where found.
  final List<UserWord> found;

  /// Creates a [UserAnswer] that does not contain any found words.
  static UserAnswer start() => UserAnswer._(const <UserWord>[]);

  @override
  Set<String> uniqueWords() => _uniqueWords(found);

  static Set<String> _uniqueWords(List<UserWord> words) => words
      .where((f) => f.evaluation == Evaluation.good)
      .map((f) => f.word)
      .toSet();

  @override
  String toString() => found.toString();
}

/// A solution is the only correct [Answer].
///
/// A solution contains all possible words that can be found on a [Board].
/// Sometimes the same word can be found by connecting different chains of
/// tiles. The getter [chains] can be used to get all possibilities.
class Solution extends Answer {
  /// Creates a [Solution]
  ///
  /// All words that can be found on the [board], are valid according to the
  /// [dictionary] and have a length greater than or equal to [minimalLength]
  /// are found.
  factory Solution(Board board, Dictionary dictionary, int minimalLength) =>
      Solution._(
          _Problem(board, dictionary, minimalLength).solve(), minimalLength);

  Solution._(Set<Chain> chains, this.minimalLength)
      : _chains = chains,
        super(Frequency.fromStrings(_uniqueWords(chains)));

  final Set<Chain> _chains;

  /// The minimal length found words should have
  final int minimalLength;

  /// Returns all found [Chain]s.
  Set<Chain> get chains => Set.from(_chains);

  @override
  Set<String> uniqueWords() => _uniqueWords(_chains);

  static Set<String> _uniqueWords(Set<Chain> words) =>
      words.map((e) => e.text).toSet();

  int _compareWords(String a, String b) {
    var compareLength = a.length.compareTo(b.length);
    return (compareLength == 0) ? a.compareTo(b) : compareLength;
  }

  /// Returns all found words sorted first by length, then alphabetically.
  List<String> uniqueWordsSorted() =>
      uniqueWords().toList()..sort((a, b) => _compareWords(a, b));

  /// Returns [true] if [word] is part of this solution, [false] otherwise.
  bool isCorrect(String word) => contains(word);
}

class _Problem {
  factory _Problem(Board board, Dictionary dict, int minimalLength) =>
      _Problem._(board, dict, minimalLength, board.mapNeighbours());

  _Problem._(this.board, this.dict, this.minimalLength, this.neighbours);

  final Board board;
  final Dictionary dict;
  final int minimalLength;
  final Map<Coordinate, Iterable<Coordinate>> neighbours;

  Queue<Chain> candidates;
  Set<Chain> words;

  Set<Chain> solve() {
    initialCandidates();
    words = Set();

    while (candidates.isNotEmpty) {
      var candidate = candidates.removeFirst();
      var last = candidate._coordinates.last;
      Iterable<Coordinate> allNeighbours = neighbours[last];
      allNeighbours
          .where((c) => !candidate._coordinates.contains(c))
          .forEach((c) => evaluateCandidate(candidate, c));
    }

    return words;
  }

  void initialCandidates() {
    candidates = ListQueue();
    var blank = Chain._blank();
    board.allCoordinates().forEach((c) => evaluateCandidate(blank, c));
  }

  void evaluateCandidate(Chain baseCandidate, Coordinate coordinate) {
    var character = board[coordinate];
    StringBuffer word = (StringBuffer(baseCandidate._text)..write(character));
    var info = dict.getInfo(word.toString());

    if (info.canStartWith) {
      var nextCandidate = Chain._extend(baseCandidate, coordinate, word);
      candidates.add(nextCandidate);

      if (info.found && word.length >= minimalLength) {
        words.add(nextCandidate);
      }
    }
  }
}

/// A chain of tiles on the board that are connected with each other and form a
/// word.
class Chain {
  Chain._blank()
      : _coordinates = [],
        _text = StringBuffer();

  Chain._extend(Chain head, Coordinate next, StringBuffer word)
      : _coordinates = List.of(head._coordinates)..add(next),
        _text = word;

  final List<Coordinate> _coordinates;
  final StringBuffer _text;

  /// The coordinates of this chain.
  List<Coordinate> get chain => List.from(_coordinates);

  /// The word that is associated with this chain.
  String get text => _text.toString();

  @override
  String toString() => '$_coordinates - $_text';
}
