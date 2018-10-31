import 'dart:collection';

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/gamelogic/histogram.dart';

abstract class Answer {
  Set<String> uniqueWords();

  bool contains(String word) => uniqueWords().contains(word);

  Histogram get histogram;
}

enum Evaluation { good, wrong, goodAgain }

class UserWord {
  final String word;
  final Evaluation eval;

  UserWord(this.word, this.eval);

  @override
  String toString() => "$word - $eval";
}

class UserAnswer extends Answer {
  final List<UserWord> found;
  @override
  final Histogram histogram;

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
      List.unmodifiable(old.found.toList()..add(UserWord(word, eval))),
    );
  }

  UserAnswer._internal(List<UserWord> found)
      : this.found = found,
        histogram = Histogram.fromStrings(_uniqueWords(found));

  static UserAnswer start() => UserAnswer._internal(const <UserWord>[]);

  @override
  Set<String> uniqueWords() => _uniqueWords(found);

  static Set<String> _uniqueWords(List<UserWord> words) =>
      words.where((f) => f.eval == Evaluation.good).map((f) => f.word).toSet();

  @override
  String toString() => found.toString();
}

class Solution extends Answer {
  final Set<Chain> _chains;
  final int minimalLength;
  @override
  final Histogram histogram;

  factory Solution(Board board, Dictionary dict, int minimalLength) {
    return Solution._internal(
        _Problem(board, dict, minimalLength).find(), minimalLength);
  }

  Solution._internal(Set<Chain> chains, this.minimalLength)
      : _chains = chains,
        histogram = Histogram.fromStrings(_uniqueWords(chains));

  Set<Chain> get chains => Set.from(_chains);

  @override
  Set<String> uniqueWords() => _uniqueWords(_chains);

  static Set<String> _uniqueWords(Set<Chain> words) =>
      words.map((e) => e.text).toSet();

  int _compareWords(String a, String b) {
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
  final int minimalLength;
  final Map<Coordinate, Iterable<Coordinate>> neighbours;

  Queue<Chain> candidates;
  Set<Chain> words;

  factory _Problem(Board board, Dictionary dict, int minimalLength) {
    return _Problem._internal(
        board, dict, minimalLength, board.mapNeighbours());
  }

  _Problem._internal(
      this.board, this.dict, this.minimalLength, this.neighbours);

  Set<Chain> find() {
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
    var character = board.characterAt(coordinate);
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

class Chain {
  final List<Coordinate> _coordinates;
  final StringBuffer _text;

  Chain._blank()
      : _coordinates = [],
        _text = StringBuffer();
  Chain._extend(Chain head, Coordinate next, StringBuffer word)
      : _coordinates = List.of(head._coordinates)..add(next),
        _text = word;

  List<Coordinate> get chain => List.from(_coordinates);
  String get text => _text.toString();

  @override
  String toString() => '$_coordinates - $_text';
}
