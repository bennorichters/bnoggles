import 'package:test/test.dart';

import 'package:bnoggles/utils/coordinate.dart';

void main() {
  var origin = Coordinate(0, 0);

  test('+', () {
     expect(origin + Coordinate(0, -1), Coordinate(0, -1));
     expect(origin + Coordinate(1, 0), Coordinate(1, 0));
     expect(origin + Coordinate(1, 5), Coordinate(1, 5));
  });

  test('allNeighbours simple', () {
    var neighbours = [
      Coordinate(0, -1),
      Coordinate(1, -1),
      Coordinate(1, 0),
      Coordinate(1, 1),
      Coordinate(0, 1),
      Coordinate(-1, 1),
      Coordinate(-1, 0),
      Coordinate(-1, -1),
    ];

    testEqualSets(origin.allNeigbours(-10, 10), neighbours);
  });

  test('allNeighbours with restrictions', () {
    var neighbours = [
      Coordinate(1, 0),
      Coordinate(1, 1),
      Coordinate(0, 1),
    ];

    testEqualSets(origin.allNeigbours(0, 10), neighbours);
  });
}

testEqualSets(Iterable actual, Iterable matcher) {
  expect(actual.toSet(), matcher.toSet());
}
