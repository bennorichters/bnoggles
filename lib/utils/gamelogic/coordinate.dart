// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

/// A pair of two integers, x and y.
///
/// Two coordinates are considered equal if and only if their x values are equal
/// and their y values are equal.
class Coordinate {
  /// Creates a [Coordinate] with the given [x] and [y] values.
  factory Coordinate(int x, int y) {
    var containsX = _cache.containsKey(x);

    if (containsX && _cache[x].containsKey(y)) return _cache[x][y];

    Coordinate coordinate = Coordinate._(x, y);
    if (!containsX) {
      _cache[x] = {};
    }
    _cache[x][y] = coordinate;

    return coordinate;
  }

  Coordinate._(this.x, this.y);

  static final Map<int, Map<int, Coordinate>> _cache = {};

  /// The x value of this coordinate
  final int x;

  /// The y value of this coordinate
  final int y;

  /// Adds this coordinate to the [other] as if both coordinates where vectors.
  /// Returns a new coordinate.
  Coordinate operator +(Coordinate other) =>
      Coordinate(x + other.x, y + other.y);

  Coordinate _neighbour(_Direction dir) => this + _neighbourVector[dir];

  /// Returns an iterable over all neighbours this coordinate has. A
  /// [Coordinate] is considered a neighbour of this if its [x] and its [y]
  /// values at most have a difference of 1 compared to the x and y values of
  /// this coordinates and it is not equal to this coordinate. The x and y
  /// values of the returned neighbours are both between min and max, both
  /// inclusive.
  Iterable<Coordinate> allNeighbours(num min, num max) => _Direction.values
      .map((d) => _neighbour(d))
      .where((c) => _withinBoundaries(c, min, max));

  /// Returns [true] if [other] is a neighbour of this, [false] otherwise.
  ///
  /// A neighbour is not the same object is [this] and either its x value
  /// or its y value or both, differ exactly one from this x and y values.
  bool isNeighbourOf(Coordinate other) =>
      (((x - other.x).abs() == 1) || ((y - other.y).abs() == 1));

  bool _withinBoundaries(Coordinate coordinate, num min, num max) =>
      ((coordinate.x >= min) &&
          (coordinate.x <= max) &&
          (coordinate.y >= min) &&
          (coordinate.y <= max));

  @override
  String toString() => "[$x,$y]";
}

enum _Direction {
  north,
  northEast,
  east,
  southEast,
  south,
  southWest,
  west,
  northWest
}

final _neighbourVector = {
  _Direction.north: Coordinate(0, -1),
  _Direction.northEast: Coordinate(1, -1),
  _Direction.east: Coordinate(1, 0),
  _Direction.southEast: Coordinate(1, 1),
  _Direction.south: Coordinate(0, 1),
  _Direction.southWest: Coordinate(-1, 1),
  _Direction.west: Coordinate(-1, 0),
  _Direction.northWest: Coordinate(-1, -1),
};
