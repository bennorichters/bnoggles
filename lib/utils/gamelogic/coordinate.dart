class Coordinate {
  static final Map<int, Map<int, Coordinate>> _cache = {};

  final int x, y;

  factory Coordinate(int x, int y) {
    var containsX = _cache.containsKey(x);

    if (containsX && _cache[x].containsKey(y)) {
      return _cache[x][y];
    }

    Coordinate coordinate = Coordinate._internal(x, y);
    if (!containsX) {
      _cache[x] = {};
    }
    _cache[x][y] = coordinate;

    return coordinate;
  }

  Coordinate._internal(this.x, this.y);

  Coordinate operator +(Coordinate c) => Coordinate(x + c.x, y + c.y);

  Coordinate _neighbour(_Direction dir) => this + _neighbourVector[dir];

  Iterable<Coordinate> allNeigbours(num min, num max) => _Direction.values
      .map((d) => _neighbour(d))
      .where((c) => _withinBoundaries(c, min, max));

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
