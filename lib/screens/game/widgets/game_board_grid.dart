import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/provider.dart';

import 'package:bnoggles/utils/board.dart';
import 'package:bnoggles/utils/coordinate.dart';
import 'package:bnoggles/utils/solution.dart';

class Grid extends StatefulWidget {
  final Map<Coordinate, Iterable<Coordinate>> neighbours;
  Grid(this.neighbours);

  @override
  GridState createState() => GridState(neighbours);
}

class GridState extends State<Grid> {
  final Map<Coordinate, Iterable<Coordinate>> neigbours;
  final List<Coordinate> _selectedPositions = [];
  final _key = GlobalKey();

  bool _validStart = false;

  GridState(this.neigbours);

  _start(PointerEvent event) {
    _validStart = Provider.of(_key.currentContext).gameOngoing;

    if (_validStart) {
      _itemHit(event);
    }
  }

  _move(PointerEvent event) {
    if (_validStart) {
      _itemHit(event);
    }
  }

  _itemHit(PointerEvent event) {
    final RenderBox box = _key.currentContext.findRenderObject();
    final result = HitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        final target = hit.target;
        if (target is _PositionedRenderObject) {
          Coordinate position = target.position;
          if (_canBeNext(position)) {
            setState(() {
              _selectedPositions.add(position);
            });
          }
        }
      }
    }
  }

  bool _canBeNext(Coordinate position) =>
      _selectedPositions.isEmpty ||
      (!_selectedPositions.contains(position) &&
          neigbours[_selectedPositions.last].contains(position));

  void _finish(PointerUpEvent event) {
    if (_validStart) {
      GameInfo gameInfo = Provider.of(_key.currentContext);
      Board board = gameInfo.board;
      Solution solution = gameInfo.solution;

      var word = StringBuffer();
      for (Coordinate position in _selectedPositions) {
        word.write(board.characterAt(position));
      }

      if (word.length >= 2) {
        var candidate = word.toString();

        UserAnswer old = gameInfo.userAnswer.value;
        gameInfo.userAnswer.value =
            UserAnswer(old, candidate, solution.isCorrect(candidate));
      }
    }

    _clearSelection();
  }

  void _clearSelection() {
    setState(() {
      _validStart = false;
      _selectedPositions.clear();
    });
  }

  static _indexToXY(int index, int width) {
    int y = (index / width).floor();
    int x = index - (y * width).floor();
    return [x, y];
  }

  @override
  Widget build(BuildContext context) {
    Board board = Provider.of(context).board;
    int width = board.width;

    num mediaWidth = MediaQuery.of(context).size.width;
    num cellWidth = mediaWidth / width;
    num padding = cellWidth / 10;
    num textSize = cellWidth / 4;

    return Container(
        margin: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
        child: Listener(
          onPointerDown: _start,
          onPointerMove: _move,
          onPointerUp: _finish,
          child: Container(
            child: GridView.builder(
              shrinkWrap: true,
              key: _key,
              itemCount: (width * width),
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width,
                childAspectRatio: 1.0,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemBuilder: (context, index) {
                var xy = _indexToXY(index, width);
                Coordinate position = Coordinate(xy[0], xy[1]);
                bool selected = _selectedPositions.contains(position);
                String character = board.characterAt(position);
                return Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border:
                        new Border.all(width: 5.0, color: Colors.blueAccent),
                    color: (selected ? Colors.lightBlueAccent : Colors.white),
                  ),
                  child: Padding(
                    padding: new EdgeInsets.all(padding),
                    child: _buildPositionedWidget(
                        position, character, selected, textSize),
                  ),
                );
              },
            ),
          ),
        ));
  }

  _PositionedWidget _buildPositionedWidget(
      Coordinate position, String character, bool selected, num textSize) {
    return _PositionedWidget(
      position: position,
      child: Container(
        // Without this line the interface is unresponsive. Not sure why.
        color: selected ? Colors.lightBlueAccent : Colors.red,

        child: Center(
            child: Text(character.toUpperCase(),
                style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.bold,
                    color: (selected ? Colors.white : Colors.black)))),
      ),
    );
  }
}

class _PositionedWidget extends SingleChildRenderObjectWidget {
  final Coordinate position;

  _PositionedWidget({Widget child, this.position, Key key})
      : super(child: child, key: key);

  @override
  _PositionedRenderObject createRenderObject(BuildContext context) {
    return _PositionedRenderObject()..position = position;
  }

  @override
  void updateRenderObject(
      BuildContext context, _PositionedRenderObject renderObject) {
    renderObject.position = position;
  }
}

class _PositionedRenderObject extends RenderProxyBox {
  Coordinate position;
}
