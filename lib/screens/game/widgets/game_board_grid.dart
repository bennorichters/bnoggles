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
  Grid(this._neighbours);
  final Map<Coordinate, Iterable<Coordinate>> _neighbours;

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  final List<Coordinate> selectedPositions = [];
  final key = GlobalKey();

  void start(PointerEvent event) {
    itemHit(event);
  }

  void move(PointerEvent event) {
    itemHit(event);
  }

  void itemHit(PointerEvent event) {
    final RenderBox box = key.currentContext.findRenderObject();
    final result = HitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        final target = hit.target;
        if (target is _PositionedRenderObject) {
          Coordinate position = target.position;
          if (canBeNext(position)) {
            setState(() {
              selectedPositions.add(position);
            });
          }
        }
      }
    }
  }

  bool canBeNext(Coordinate position) =>
      selectedPositions.isEmpty ||
      (!selectedPositions.contains(position) &&
          widget._neighbours[selectedPositions.last].contains(position));

  void finish(PointerUpEvent event) {
    GameInfo gameInfo = Provider.of(key.currentContext);
    Board board = gameInfo.board;
    Solution solution = gameInfo.solution;

    var word = StringBuffer();
    for (Coordinate position in selectedPositions) {
      word.write(board[position]);
    }

    if (word.length >= gameInfo.solution.minimalLength) {
      var candidate = word.toString();

      UserAnswer old = gameInfo.userAnswer.value;
      gameInfo.userAnswer.value =
          UserAnswer(old, candidate, solution.isCorrect(candidate));
    }

    clearSelection();
  }

  void clearSelection() {
    setState(() {
      selectedPositions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Board board = Provider.of(context).board;

    double mediaWidth = MediaQuery.of(context).size.width;
    double cellWidth = mediaWidth / board.width;

    return Container(
      key: key,
      margin: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
      child: Listener(
        onPointerDown: start,
        onPointerMove: move,
        onPointerUp: finish,
        child: Container(
          child: BoardWidget(
            board: board,
            centeredCharacter: _HittableCenteredCharacter(cellWidth),
            selectedPositions: selectedPositions,
          ),
        ),
      ),
    );
  }
}

class _HittableCenteredCharacter extends CenteredCharacter {
  _HittableCenteredCharacter(double cellWidth) : super(cellWidth);

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
  _PositionedWidget({Widget child, this.position, Key key})
      : super(child: child, key: key);

  final Coordinate position;

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
