// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/lettter_frequency.dart';

typedef List<Coordinate> Shuffler(List<Coordinate> toShuffle);

class Board {
  final Map<Coordinate, String> _tiles;
  final Shuffler _shuffler;

  Board._(this._tiles, this._shuffler);

  factory Board._unmodifiable(
          Map<Coordinate, String> tiles, Shuffler shuffler) =>
      Board._(Map.unmodifiable(tiles), shuffler);

  factory Board(int width, LetterGenerator gen, [Shuffler shuffler]) =>
      _BoardFactory(
        width,
        gen,
        shuffler ?? (list) => list..shuffle(),
      ).build();

  int get width => sqrt(_tiles.length).floor();

  String characterAt(Coordinate coordinate) => _tiles[coordinate];

  Iterable<Coordinate> allCoordinates() => _tiles.keys;

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

    Map<Coordinate, String> copy = Map.from(_tiles);

    List<Coordinate> chain = [];
    Coordinate current = _shuffler((allCoordinates().toList()))[0];
    for (int i = 0; i < word.length; i++) {
      chain.add(current);
      copy[current] = word.substring(i, i + 1);

      if (i < word.length - 1) {
        current = _shuffler(current
            .allNeighbours(0, width - 1)
            .where((c) => !chain.contains(c))
            .toList())[0];
      }
    }

    return Board._unmodifiable(copy, _shuffler);
  }

  @override
  String toString() {
    var result = <String>[];
    for (var y = 0; y < width; y++) {
      var line = StringBuffer();
      for (var x = 0; x < width; x++) {
        line.write(_tiles[Coordinate(x, y)]);
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
  final Map<Coordinate, String> tiles = Map();

  _BoardFactory(this.width, this.gen, this.shuffler);

  Board build() {
    emptyBoard();

    int left = tiles.keys.length;
    while (left > 0) {
      left -= addLetterSequence();
    }

    return Board._unmodifiable(tiles, shuffler);
  }

  int addLetterSequence() {
    String letterSequence;
    List<Coordinate> chain;

    while (chain == null) {
      letterSequence = gen.next();
      chain = freeChain(
        shuffler(tiles.keys.where((k) => tiles[k] == null).toList()),
        letterSequence.length,
      );

      if (chain == null) {
        gen.decreaseLength();
      }
    }

    for (int i = 0; i < letterSequence.length; i++) {
      tiles[chain[i]] = letterSequence.substring(i, i + 1);
    }

    return letterSequence.length;
  }

  void emptyBoard() {
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < width; y++) {
        tiles[Coordinate(x, y)] = null;
      }
    }
  }

  List<Coordinate> freeChain(Iterable<Coordinate> candidates, int length,
      [List<Coordinate> found = const []]) {
    if (length == 0) return found;

    if (candidates.length == 0) return null;

    for (Coordinate candidate in candidates) {
      List<Coordinate> nextCandidates = shuffler(candidate
          .allNeighbours(0, width - 1)
          .where((c) => (tiles[c] == null) && !found.contains(c))
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
