import 'dart:math';

import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/dictionary.dart';

class Board {
  final Map<Coordinate, String> cell;

  factory Board(int width, RandomLetterGenerator gen) {
    var cell = <Coordinate, String>{};
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < width; y++) {
        cell[Coordinate(x, y)] = gen.next();
      }
    }

    return Board._internal(Map.unmodifiable(cell));
  }

  Board._internal(this.cell);

  int get width => sqrt(cell.length).floor();

  String characterAt(Coordinate coordinate) => cell[coordinate];

  Iterable<Coordinate> allCoordinates() => cell.keys;

  Map<Coordinate, Iterable<Coordinate>> mapNeighbours() {
    var contents = <Coordinate, Iterable<Coordinate>>{};
    allCoordinates().forEach((c) => contents[c] = c.allNeigbours(0, width - 1));
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
