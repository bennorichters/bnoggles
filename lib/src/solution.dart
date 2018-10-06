import 'dart:collection';

import 'board.dart';
import 'coordinate.dart';
import 'dictionary.dart';

Set<Solution> solve(Board board, Dictionary dict) {
  return _Problem(board, dict).find();
}

class _Problem {
  final Board board;
  final Dictionary dict;
  final Map neighbours;

  Queue<Solution> candidates;
  Set<Solution> words;

  factory _Problem(Board board, Dictionary dict) {
    return _Problem._internal(board, dict, mapNeighbours(board));
  }

  static Map<Coordinate, Iterable<Coordinate>> mapNeighbours(Board board) {
    return Map.unmodifiable(Map.fromIterable(board.allCoordinates(),
        key: (item) => item,
        value: (item) => item.allNeigbours(0, board.width - 1)));
  }

  _Problem._internal(this.board, this.dict, this.neighbours);

  Set<Solution> find() {
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
    var blank = Solution._blank();
    board.allCoordinates().forEach((c) => evaluateCandidate(blank, c));
  }

  void evaluateCandidate(Solution baseCandidate, Coordinate coord) {
    var character = board.characterAt(coord);
    StringBuffer word = (StringBuffer(baseCandidate._word)..write(character));
    var info = dict.getInfo(word.toString());

    if (info.canStartWith) {
      var nextCandidate = Solution._extend(baseCandidate, coord, word);
      candidates.add(nextCandidate);

      if (info.found) {
        words.add(nextCandidate);
      }
    }
  }
}

class Solution {
  final List<Coordinate> _chain;
  final StringBuffer _word;

  get chain => List.from(_chain);
  get word => _word.toString();

  Solution._blank()
      : _chain = [],
        _word = StringBuffer();

  Solution._extend(Solution head, Coordinate next, StringBuffer word)
      : _chain = List.of(head._chain)..add(next),
        _word = word;

  @override
  toString() => '$_chain - $_word';
}
