import 'dart:math';

import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/dictionary.dart';

class Board {
  final Map<Coordinate, String> cell;

  factory Board(int width, RandomLetterGenerator gen) {
    return _BoardFactory(width, gen).build();
  }

  Board._internal(this.cell);

  int get width => sqrt(cell.length).floor();

  String characterAt(Coordinate coordinate) => cell[coordinate];

  Iterable<Coordinate> allCoordinates() => cell.keys;

  Map<Coordinate, Iterable<Coordinate>> mapNeighbours() {
    var contents = <Coordinate, Iterable<Coordinate>>{};
    allCoordinates()
        .forEach((c) => contents[c] = c.allNeighbours(0, width - 1));
    return Map.unmodifiable(contents);
  }

  @override
  String toString() {
    var result = <String>[];
    for (var y = 0; y < width; y++) {
      var line = StringBuffer();
      for (var x = 0; x < width; x++) {
        line.write(cell[Coordinate(x, y)]);
      }
      result.add(line.toString());
    }

    return result.join("\n");
  }
}

class _BoardFactory {
  final int _width;
  final RandomLetterGenerator _gen;
  final Map<Coordinate, String> _map = Map();
  final Random _rand = Random();

  _BoardFactory(this._width, this._gen);

  Board build() {
    emptyBoard();

    int left = _map.keys.length;
    int maxLength = left;
    while (left > 0) {
      String letter;
      List<Coordinate> chain;

      bool found = false;
      while (!found) {
        letter = _gen.next(maxLength: maxLength);
        chain = freeChain(_map.keys.where((k) => _map[k] == null).toList(),
            letter.length, []);

        if (chain == null) {
          maxLength--;

          if (maxLength == 0) {
            throw StateError("letters do not fit in board");
          }
        } else {
          found = true;
        }
      }

      for (int i = 0; i < letter.length; i++) {
        _map[chain[i]] = letter.substring(i, i + 1);
      }
      left -= letter.length;
    }

    return Board._internal(Map.unmodifiable(_map));
  }

  void emptyBoard() {
    for (var x = 0; x < _width; x++) {
      for (var y = 0; y < _width; y++) {
        _map[Coordinate(x, y)] = null;
      }
    }
  }

  List<Coordinate> freeChain(
      List<Coordinate> candidates, int length, List<Coordinate> found) {
    if (length == 0) {
      return found;
    }

    if (candidates.length == 0) {
      return null;
    }

    for (Coordinate candidate in candidates) {
      List<Coordinate> nextCandidates = candidate
          .allNeighbours(0, _width - 1)
          .where((c) => (_map[c] == null) && !found.contains(c))
          .toList()
        ..shuffle(_rand);

      var result =
      freeChain(nextCandidates, length - 1, List.of(found)..add(candidate));

      if (result != null) {
        return result;
      }
    }

    return null;
  }
}
