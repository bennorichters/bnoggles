import 'dart:math';

import 'coordinate.dart';
import 'dictionary.dart';

class Board {
  final Map<Coordinate, String> cell;

  factory Board(int width, RandomLetterGenerator gen) {
    var cell = {};
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < width; y++) {
        cell[Coordinate(x, y)] = gen.next();
      }
    }

    return Board._internal(Map.unmodifiable(cell));
  }

  Board._internal(this.cell);

  int get width => sqrt(cell.length).floor();

  characterAt(Coordinate coordinate) => cell[coordinate];

  Iterable<Coordinate> allCoordinates() => cell.keys;

  @override
  toString() {
    var result = [];
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
