import 'dart:collection';

import 'package:bnoggles/utils/board.dart';
import 'package:bnoggles/utils/coordinate.dart';
import 'package:bnoggles/utils/dictionary.dart';

abstract class Answer {
  Set<String> uniqueWords();

  bool contains(String word) => uniqueWords().contains(word);

  int countForLength(int length) =>
      uniqueWords().where((w) => w.length == length).length;

  int countForMinLength(int minLength) =>
      uniqueWords().where((w) => w.length >= minLength).length;
}

enum Evaluation { good, wrong, goodAgain }

class UserWord {
  final String word;
  final Evaluation eval;

  UserWord(this.word, this.eval);
}

class UserAnswer extends Answer {
  final List<UserWord> found;

  factory UserAnswer(UserAnswer old, String word, bool isCorrect) {
    Evaluation eval;

    if (isCorrect && old.contains(word)) {
      eval = Evaluation.goodAgain;
    } else if (isCorrect) {
      eval = Evaluation.good;
    } else {
      eval = Evaluation.wrong;
    }

    return UserAnswer._internal(
        List.unmodifiable(old.found.toList()..add(UserWord(word, eval))));
  }

  UserAnswer._internal(this.found);

  static UserAnswer start() => UserAnswer._internal(List.unmodifiable([]));

  @override
  Set<String> uniqueWords() =>
      found.where((f) => f.eval == Evaluation.good).map((f) => f.word).toSet();
}

class Solution extends Answer {
  final Set<Chain> _words;

  factory Solution(Board board, Dictionary dict) {
    return Solution._internal(_Problem(board, dict).find());
  }

  Solution._internal(this._words);

  Set<String> uniqueWords() => _words.map((e) => e.text).toSet();

  num _compareWords(String a, String b) {
    var compareLength = a.length.compareTo(b.length);
    return (compareLength == 0) ? a.compareTo(b) : compareLength;
  }

  List<String> uniqueWordsSorted() =>
      uniqueWords().toList()..sort((a, b) => _compareWords(a, b));

  bool isCorrect(String text) => uniqueWords().contains(text);
}

class _Problem {
  final Board board;
  final Dictionary dict;
  final Map neighbours;

  Queue<Chain> candidates;
  Set<Chain> words;

  factory _Problem(Board board, Dictionary dict) {
    return _Problem._internal(board, dict, mapNeighbours(board));
  }

  static Map<Coordinate, Iterable<Coordinate>> mapNeighbours(Board board) {
    return Map.unmodifiable(Map.fromIterable(board.allCoordinates(),
        key: (item) => item,
        value: (item) => item.allNeigbours(0, board.width - 1)));
  }

  _Problem._internal(this.board, this.dict, this.neighbours);

  Set<Chain> find() {
    initialCandidates();
    words = Set();

    while (candidates.isNotEmpty) {
      var candidate = candidates.removeFirst();
      var last = candidate._coordinates.last;
      var allNeighbours = neighbours[last];
      allNeighbours
          .where((c) => !candidate._coordinates.contains(c))
          .forEach((c) => evaluateCandidate(candidate, c));
    }

    return words;
  }

  initialCandidates() {
    candidates = ListQueue();
    var blank = Chain._blank();
    board.allCoordinates().forEach((c) => evaluateCandidate(blank, c));
  }

  void evaluateCandidate(Chain baseCandidate, Coordinate coordinate) {
    var character = board.characterAt(coordinate);
    StringBuffer word = (StringBuffer(baseCandidate._text)..write(character));
    var info = dict.getInfo(word.toString());

    if (info.canStartWith) {
      var nextCandidate = Chain._extend(baseCandidate, coordinate, word);
      candidates.add(nextCandidate);

      if (info.found) {
        words.add(nextCandidate);
      }
    }
  }
}

class Chain {
  final List<Coordinate> _coordinates;
  final StringBuffer _text;

  List<Coordinate> get chain => List.from(_coordinates);
  String get text => _text.toString();

  Chain._blank()
      : _coordinates = [],
        _text = StringBuffer();

  Chain._extend(Chain head, Coordinate next, StringBuffer word)
      : _coordinates = List.of(head._coordinates)..add(next),
        _text = word;

  @override
  toString() => '$_coordinates - $_text';
}
