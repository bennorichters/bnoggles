import 'dart:math';

import 'package:bnoggles/utils/coordinate.dart';
import 'package:bnoggles/utils/dictionary.dart';

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

  Map<Coordinate, Iterable<Coordinate>> mapNeighbours() =>
      Map.unmodifiable(Map.fromIterable(allCoordinates(),
          key: (item) => item,
          value: (item) => item.allNeigbours(0, width - 1)));

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
