// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/widgets/board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/provider.dart';

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';

class Grid extends StatefulWidget {
  final Map<Coordinate, Iterable<Coordinate>> neighbours;
  Grid(this.neighbours);

  @override
  GridState createState() => GridState(neighbours);
}

class GridState extends State<Grid> {
  final Map<Coordinate, Iterable<Coordinate>> neighbours;
  final List<Coordinate> _selectedPositions = [];
  final _key = GlobalKey();

  GridState(this.neighbours);

  void _start(PointerEvent event) {
    _itemHit(event);
  }

  void _move(PointerEvent event) {
    _itemHit(event);
  }

  void _itemHit(PointerEvent event) {
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
          neighbours[_selectedPositions.last].contains(position));

  void _finish(PointerUpEvent event) {
    GameInfo gameInfo = Provider.of(_key.currentContext);
    Board board = gameInfo.board;
    Solution solution = gameInfo.solution;

    var word = StringBuffer();
    for (Coordinate position in _selectedPositions) {
      word.write(board[position]);
    }

    if (word.length >= gameInfo.solution.minimalLength) {
      var candidate = word.toString();

      UserAnswer old = gameInfo.userAnswer.value;
      gameInfo.userAnswer.value =
          UserAnswer(old, candidate, solution.isCorrect(candidate));
    }

    _clearSelection();
  }

  void _clearSelection() {
    setState(() {
      _selectedPositions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Board board = Provider.of(context).board;

    double mediaWidth = MediaQuery.of(context).size.width;
    double cellWidth = mediaWidth / board.width;

    return Container(
      key: _key,
      margin: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
      child: Listener(
        onPointerDown: _start,
        onPointerMove: _move,
        onPointerUp: _finish,
        child: Container(
          child: BoardWidget(
            board: board,
            centeredCharacter: HittableCenteredCharacter(cellWidth),
            selectedPositions: _selectedPositions,
          ),
        ),
      ),
    );
  }
}

class HittableCenteredCharacter extends CenteredCharacter {
  HittableCenteredCharacter(double cellWidth) : super(cellWidth);

  @override
  Widget create({
    String character,
    bool selected,
    Coordinate position,
  }) {
    Widget child = super
        .create(character: character, selected: selected, position: position);

    return Padding(
      padding: EdgeInsets.all(cellWidth / 8),
      child: _PositionedWidget(
        position: position,
        child: Container(
          // Without this line the interface is unresponsive. Not sure why.
          color: selected ? Colors.lightBlueAccent : Colors.white,

          child: child,
        ),
      ),
    );
  }
}

class _PositionedWidget extends SingleChildRenderObjectWidget {
  final Coordinate position;

  _PositionedWidget({Widget child, this.position, Key key})
      : super(child: child, key: key);

  @override
  _PositionedRenderObject createRenderObject(BuildContext context) =>
      _PositionedRenderObject()..position = position;

  @override
  void updateRenderObject(
      BuildContext context, _PositionedRenderObject renderObject) {
    renderObject.position = position;
  }
}

class _PositionedRenderObject extends RenderProxyBox {
  Coordinate position;
}
