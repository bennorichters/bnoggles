import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/provider.dart';

import 'package:bnoggles/utils/board.dart';
import 'package:bnoggles/utils/coordinate.dart';
import 'package:bnoggles/utils/solution.dart';

class Grid extends StatefulWidget {
  @override
  GridState createState() {
    return new GridState();
  }
}

class GridState extends State<Grid> {
  final List<int> _selectedIndexes = [];
  final _key = GlobalKey();

  bool _validStart = false;

  _start(PointerEvent event) {
    _validStart = true;
    _detectTapedItem(event);
  }

  _move(PointerEvent event) {
    if (_validStart) {
      _detectTapedItem(event);
    }
  }

  _detectTapedItem(PointerEvent event) {
    final RenderBox box = _key.currentContext.findRenderObject();
    final result = HitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        if (target is _IndexedRenderObject) {
          if (!_selectedIndexes.contains(target.index)) {
            setState(() {
              _selectedIndexes.add(target.index);
            });
          } else if (_selectedIndexes.last != target.index) {
            _clearSelection();
          }
        }
      }
    }
  }

  void _finish(PointerUpEvent event) {
    if (_validStart) {
      Board board = Provider.immutableDataOf(_key.currentContext)["board"];
      Solution solution =
          Provider.immutableDataOf(_key.currentContext)["solution"];

      var word = StringBuffer();
      for (var index in _selectedIndexes) {
        var xy = _indexToXY(index, board.width);
        word.write(board.characterAt(Coordinate(xy[0], xy[1])));
      }

      var candidate = word.toString();

      UserAnswer old = Provider.mutableDataOf(_key.currentContext).value;
      Provider.mutableDataOf(_key.currentContext).value =
          UserAnswer.extend(old, candidate, solution.isCorrect(candidate));
    }

    _clearSelection();
  }

  void _clearSelection() {
    setState(() {
      _validStart = false;
      _selectedIndexes.clear();
    });
  }

  static _indexToXY(int index, int width) {
    int y = (index / width).floor();
    int x = index - (y * width).floor();
    return [x, y];
  }

  @override
  Widget build(BuildContext context) {
    Board board = Provider.immutableDataOf(context)["board"];

    return Container(
        margin: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
        child: Listener(
          onPointerDown: _start,
          onPointerMove: _move,
          onPointerUp: _finish,
          child: Container(
//        width: 300.0,
            child: GridView.builder(
              shrinkWrap: true,
              key: _key,
              itemCount: 9,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
              ),
              itemBuilder: (context, index) {
                var xy = _indexToXY(index, board.width);
                String character = board.characterAt(Coordinate(xy[0], xy[1]));
                return Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      border: new Border.all(color: Colors.blueAccent)),
                  child: Padding(
                    padding: new EdgeInsets.all(35.0),
                    child: _buildIndexedWidget(index, character),
                  ),
                );
              },
            ),
          ),
        ));
  }

  _IndexedWidget _buildIndexedWidget(int index, String character) {
    bool selected = _selectedIndexes.contains(index);
    return _IndexedWidget(
      index: index,
      child: Container(
        color: selected ? Colors.lightBlueAccent : Colors.deepPurple,
        child: Center(
            child: Text(character.toUpperCase(),
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: (selected ? Colors.black : Colors.white)))),
      ),
    );
  }
}

class _IndexedWidget extends SingleChildRenderObjectWidget {
  final int index;

  _IndexedWidget({Widget child, this.index, Key key})
      : super(child: child, key: key);

  @override
  _IndexedRenderObject createRenderObject(BuildContext context) {
    return _IndexedRenderObject()..index = index;
  }

  @override
  void updateRenderObject(
      BuildContext context, _IndexedRenderObject renderObject) {
    renderObject..index = index;
  }
}

class _IndexedRenderObject extends RenderProxyBox {
  int index;
}
