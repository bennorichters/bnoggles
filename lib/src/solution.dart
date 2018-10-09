import 'dart:collection';

import 'package:collection/collection.dart';

import 'board.dart';
import 'coordinate.dart';
import 'dictionary.dart';

class Solution {
  final Set<Word> _words;

  factory Solution(Board board, Dictionary dict) {
    return Solution._internal(_Problem(board, dict).find());
  }

  Solution._internal(this._words);

  num _compareWords(String a, String b) {
    var compareLength = a.length.compareTo(b.length);
    return (compareLength == 0) ? a.compareTo(b) : compareLength;
  }

  Set<String> _uniqueWords() => _words.map((e) => e.text).toSet();

  List<String> uniqueWordsSorted() =>
      _uniqueWords().toList()..sort((a, b) => _compareWords(a, b));

  Map<int, int> wordsPerLengthCount() =>
      groupBy(_uniqueWords(), (w) => w.length)
          .map((k, v) => MapEntry(k, v.length))
          .cast<int, int>();

  bool isCorrect(String text) => _uniqueWords().contains(text);
}

class _Problem {
  final Board board;
  final Dictionary dict;
  final Map neighbours;

  Queue<Word> candidates;
  Set<Word> words;

  factory _Problem(Board board, Dictionary dict) {
    return _Problem._internal(board, dict, mapNeighbours(board));
  }

  static Map<Coordinate, Iterable<Coordinate>> mapNeighbours(Board board) {
    return Map.unmodifiable(Map.fromIterable(board.allCoordinates(),
        key: (item) => item,
        value: (item) => item.allNeigbours(0, board.width - 1)));
  }

  _Problem._internal(this.board, this.dict, this.neighbours);

  Set<Word> find() {
    initialCandidates();
    words = Set();

    while (candidates.isNotEmpty) {
      var candidate = candidates.removeFirst();
      var last = candidate._chain.last;
      var allNeigbours = neighbours[last];
      allNeigbours
          .where((c) => !candidate._chain.contains(c))
          .forEach((c) => evaluateCandidate(candidate, c));
    }

    return words;
  }

  initialCandidates() {
    candidates = ListQueue();
    var blank = Word._blank();
    board.allCoordinates().forEach((c) => evaluateCandidate(blank, c));
  }

  void evaluateCandidate(Word baseCandidate, Coordinate coord) {
    var character = board.characterAt(coord);
    StringBuffer word = (StringBuffer(baseCandidate._text)..write(character));
    var info = dict.getInfo(word.toString());

    if (info.canStartWith) {
      var nextCandidate = Word._extend(baseCandidate, coord, word);
      candidates.add(nextCandidate);

      if (info.found) {
        words.add(nextCandidate);
      }
    }
  }
}

class Word {
  final List<Coordinate> _chain;
  final StringBuffer _text;

  List<Coordinate> get chain => List.from(_chain);
  String get text => _text.toString();

  Word._blank()
      : _chain = [],
        _text = StringBuffer();

  Word._extend(Word head, Coordinate next, StringBuffer word)
      : _chain = List.of(head._chain)..add(next),
        _text = word;

  @override
  toString() => '$_chain - $_text';
}
