// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/coordinate.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  final List<Coordinate> selectedPositions;
  final Board board;
  final CenteredCharacter centeredCharacter;

  const BoardWidget(
      {Key key,
      @required this.selectedPositions,
      @required this.board,
      @required this.centeredCharacter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int width = board.width;

    return GridView.builder(
      shrinkWrap: true,
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
        bool selected = selectedPositions.contains(position);
        String character = board.characterAt(position);
        return Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: new Border.all(width: 5.0, color: Colors.blueAccent),
            color: (selected ? Colors.lightBlueAccent : Colors.white),
          ),
          child: centeredCharacter.create(
            selected: selected,
            character: character,
            position: position,
          ),
        );
      },
    );
  }

  static List<int> _indexToXY(int index, int width) {
    int y = (index / width).floor();
    int x = index - (y * width).floor();
    return [x, y];
  }
}

class CenteredCharacter {
  final double cellWidth;
  CenteredCharacter(this.cellWidth);

  Widget create({
    @required String character,
    @required bool selected,
    Coordinate position,
  }) =>
      Center(
        child: Text(
          character.toUpperCase(),
          style: TextStyle(
            fontSize: cellWidth / 4,
            fontWeight: FontWeight.bold,
            color: (selected ? Colors.white : Colors.black),
          ),
        ),
      );
}
