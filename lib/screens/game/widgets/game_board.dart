// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/game_info.dart';
import 'package:bnoggles/widgets/board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/game_info_provider.dart';

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';

/// Widget that allows the user to swipe through a grid of letters to find
/// hidden words.
///
/// This [GameBoard] needs to be a descendant of [GameInfoProvider] which contains all
/// relevant information.
class GameBoard extends StatefulWidget {
  /// Creates an instance of [GameBoard].
  const GameBoard();

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final List<Coordinate> selectedPositions = [];
  final key = GlobalKey();

  void finish(PointerUpEvent event) {
    GameInfo gameInfo = GameInfoProvider.of(key.currentContext);
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
          old.add(candidate, solution.isCorrect(candidate));
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
    Board board = GameInfoProvider.of(context).board;

    double mediaWidth = MediaQuery.of(context).size.width;
    double cellWidth = mediaWidth / board.width;

    bool canBeNext(Coordinate position) =>
        selectedPositions.isEmpty ||
        (!selectedPositions.contains(position) &&
            selectedPositions.last.isNeighbourOf(position));

    void startAndMove(PointerEvent event) {
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

    return Container(
      key: key,
      margin: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
      child: Listener(
        onPointerDown: startAndMove,
        onPointerMove: startAndMove,
        onPointerUp: finish,
        child: Container(
          child: BoardWidget(
            cellWidth: cellWidth,
            board: board,
            centeredCharacter: _hittableGridCellProvider,
            selectedPositions: selectedPositions,
          ),
        ),
      ),
    );
  }
}

Widget _hittableGridCellProvider({
  double cellWidth,
  String character,
  bool selected,
  Coordinate position,
}) =>
    _HittableGridCell(cellWidth, character, selected, position);

class _HittableGridCell extends StatelessWidget {
  _HittableGridCell(
    this.cellWidth,
    this.character,
    this.selected,
    this.position,
  );

  final double cellWidth;
  final String character;
  final bool selected;
  final Coordinate position;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(cellWidth / 8),
      child: _PositionedWidget(
        position: position,
        child: Container(
          // Without this line the interface is unresponsive. Not sure why.
          color: selected ? Colors.lightBlueAccent : Colors.white,

          child: defaultCellProvider(
            cellWidth: cellWidth,
            character: character,
            selected: selected,
            position: position,
          ),
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
