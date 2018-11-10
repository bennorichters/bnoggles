// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/lettter_sequence.dart';

/// A shuffler returns a new list with the same elements as [toShuffle] but
/// it can change the order.
typedef List<Coordinate> Shuffler(List<Coordinate> toShuffle);

/// An abstract representation of the board on which the game is played.
///
/// A board maps a [Coordinate] to a letter. All boards are square, i.e. they
/// have the same width as height. A [SequenceGenerator] is used to fill the board
/// with different letters.
class Board {
  final Map<Coordinate, String> _tiles;
  final Shuffler _shuffler;

  Board._(this._tiles, this._shuffler);

  factory Board._unmodifiable(
          Map<Coordinate, String> tiles, Shuffler shuffler) =>
      Board._(Map.unmodifiable(tiles), shuffler);

  /// Creates a [Board].
  ///
  /// The board will contain [width]*[width] [Coordinate]s. The [generator]
  /// is used to generate a letter for each coordinate. The [shuffler]
  /// determines the order in which the coordinates are mapped. [List.shuffle]
  /// is used when [shuffler] is omitted.
  factory Board(int width, SequenceGenerator generator, [Shuffler shuffler]) =>
      _BoardFactory(
        width,
        generator,
        shuffler ?? (list) => list..shuffle(),
      ).build();

  /// The width of this board
  int get width => sqrt(_tiles.length).floor();

  /// The letter the [coordinate] is mapped to.
  String operator [](Coordinate coordinate)  => _tiles[coordinate];

  /// An iterable over all coordinates in the board. The number of coordinates
  /// equals [width]*[width].
  Iterable<Coordinate> allCoordinates() => _tiles.keys;

  /// A map where each coordinate is mapped to all the neighbours it has. A
  /// [Coordinate] is considered a neighbour of another coordinate if its
  /// [Coordinate.x] and its [Coordinate.y] values at most have a difference of
  /// 1 and both coordinates are not equal and x and y are both between zero
  /// (inclusive) and width (exclusive).
  Map<Coordinate, Iterable<Coordinate>> mapNeighbours() {
    var contents = <Coordinate, Iterable<Coordinate>>{};
    allCoordinates()
        .forEach((c) => contents[c] = c.allNeighbours(0, width - 1));
    return Map.unmodifiable(contents);
  }

  /// Inserts the given [word] at a random place and returns a new instance of
  /// [Board]. The new board is an exact copy of the old board, except that some
  /// coordinates in the new board are now mapped to the letters of the given
  /// word. These coordinates are determined by the shuffler as passed into the
  /// constructor.
  Board insertWordRandomly(String word) {
    assert(
        word.length <= 4, "word length should be max 4 but is ${word.length}");

    // For longer lengths the algorithm should check if the chain doesn't lock
    // itself in. For instance: (1, 1); (0, 1); (1, 0); (0, 0)

    Map<Coordinate, String> copy = Map.from(_tiles);

    List<Coordinate> chain = [];
    Coordinate current = _shuffler((allCoordinates().toList())).first;
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
  final SequenceGenerator gen;
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
