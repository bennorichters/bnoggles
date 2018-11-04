// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/lettter_frequency.dart';

typedef List<Coordinate> Shuffler(List<Coordinate> toShuffle);

class Board {
  final Map<Coordinate, String> cells;
  final Shuffler shuffler;

  Board._(this.cells, this.shuffler);

  factory Board._unmodifiable(
          Map<Coordinate, String> cells, Shuffler shuffler) =>
      Board._(Map.unmodifiable(cells), shuffler);

  factory Board(int width, LetterGenerator gen, [Shuffler shuffler]) =>
      _BoardFactory(
        width,
        gen,
        shuffler ?? (list) => list..shuffle(),
      ).build();

  int get width => sqrt(cells.length).floor();

  String characterAt(Coordinate coordinate) => cells[coordinate];

  Iterable<Coordinate> allCoordinates() => cells.keys;

  Map<Coordinate, Iterable<Coordinate>> mapNeighbours() {
    var contents = <Coordinate, Iterable<Coordinate>>{};
    allCoordinates()
        .forEach((c) => contents[c] = c.allNeighbours(0, width - 1));
    return Map.unmodifiable(contents);
  }

  Board insertWordRandomly(String word) {
    assert(
        word.length <= 4, "word length should be max 4 but is ${word.length}");

    // For longer lengths the algorithm should check if the chain doesn't lock
    // itself in. For instance: (1, 1); (0, 1); (1, 0); (0, 0)

    Map<Coordinate, String> copy = Map.from(cells);

    List<Coordinate> chain = [];
    Coordinate current = shuffler((allCoordinates().toList()))[0];
    for (int i = 0; i < word.length; i++) {
      chain.add(current);
      copy[current] = word.substring(i, i + 1);

      if (i < word.length - 1) {
        current = shuffler(current.allNeighbours(0, width - 1).toList())
            .firstWhere((c) => !chain.contains(c));
      }
    }

    return Board._unmodifiable(copy, shuffler);
  }

  @override
  String toString() {
    var result = <String>[];
    for (var y = 0; y < width; y++) {
      var line = StringBuffer();
      for (var x = 0; x < width; x++) {
        line.write(cells[Coordinate(x, y)]);
      }
      result.add(line.toString());
    }

    return result.join("\n");
  }
}

class _BoardFactory {
  final int width;
  final LetterGenerator gen;
  final Shuffler shuffler;
  final Map<Coordinate, String> map = Map();

  _BoardFactory(this.width, this.gen, this.shuffler);

  Board build() {
    emptyBoard();

    int left = map.keys.length;
    while (left > 0) {
      String letter;
      List<Coordinate> chain;

      bool found = false;
      while (!found) {
        letter = gen.next();
        chain = freeChain(
          shuffler(map.keys.where((k) => map[k] == null).toList()),
          letter.length,
        );

        if (chain == null) {
          gen.decreaseLength();
        } else {
          found = true;
        }
      }

      for (int i = 0; i < letter.length; i++) {
        map[chain[i]] = letter.substring(i, i + 1);
      }
      left -= letter.length;
    }

    return Board._unmodifiable(map, shuffler);
  }

  void emptyBoard() {
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < width; y++) {
        map[Coordinate(x, y)] = null;
      }
    }
  }

  List<Coordinate> freeChain(Iterable<Coordinate> candidates, int length,
      [List<Coordinate> found = const []]) {
    if (length == 0) {
      return found;
    }

    if (candidates.length == 0) {
      return null;
    }

    for (Coordinate candidate in candidates) {
      List<Coordinate> nextCandidates = shuffler(candidate
          .allNeighbours(0, width - 1)
          .where((c) => (map[c] == null) && !found.contains(c))
          .toList());

      var result = freeChain(
        nextCandidates,
        length - 1,
        List.of(found)..add(candidate),
      );

      if (result != null) {
        return result;
      }
    }

    return null;
  }
}
