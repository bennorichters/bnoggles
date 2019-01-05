// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/answer.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';

import 'package:bnoggles/utils/game_info.dart';

import '../../test_helper.dart';

class MockParameters extends Mock implements GameParameters {}

class MockBoard extends Mock implements Board {}

class MockSolution extends Mock implements Solution {}

void main() {
  test('getters', () async {
    var mockParameters = MockParameters();
    var mockBoard = MockBoard();
    var mockSolution = MockSolution();
    var vua = ValueNotifier(UserAnswer.start());

    when(mockSolution.uniqueWords()).thenReturn(['abc'].toSet());

    GameInfo info = GameInfo(
      parameters: mockParameters,
      currentPlayer: 0,
      board: mockBoard,
      solution: mockSolution,
      allUserAnswers: [vua],
    );

    expect(info.parameters, mockParameters);
    expect(info.board, mockBoard);
    expect(info.solution, mockSolution);
    expect(info.userAnswer, vua);
  });

  test('randomWords', () async {
    var words = ['abc', 'def', 'ghi'];

    GameInfo info = GameInfo(
      parameters: null,
      currentPlayer: 0,
      board: null,
      solution: createMockSolution(words, 2),
      allUserAnswers: [
        ValueNotifier(UserAnswer.start()),
      ],
    );

    expect(info.randomWords.toList()..sort(), words);
  });

  test('answer listeners', () async {
    ValueNotifier<UserAnswer> vua =
        ValueNotifier(UserAnswer.start().add('abc', true));

    GameInfo info = GameInfo(
      parameters: null,
      currentPlayer: 0,
      board: null,
      solution: createMockSolution(['abc', 'def', 'ghi'], 2),
      allUserAnswers: [vua],
    );

    var flag = false;
    void toggleFlag() {
      flag = !flag;
    }

    info.addUserAnswerListener(toggleFlag);
    vua.value = vua.value.add('d', false);
    expect(flag, true);

    info.removeUserAnswerListener(toggleFlag);
    vua.value = vua.value.add('e', false);
    expect(flag, true);
  });

  test('availableWordsCount', () {
    GameInfo info = GameInfo(
      parameters: null,
      currentPlayer: 0,
      board: null,
      solution: createMockSolution(['abc', 'def', 'ghi'], 2),
      allUserAnswers: [
        ValueNotifier(UserAnswer.start().add('abc', true)),
      ],
    );

    expect(info.availableWordsCount(), 3);
  });

  test('list of number of found words for each player', () {
    GameInfo info = GameInfo(
      parameters: null,
      currentPlayer: 0,
      board: null,
      solution: createMockSolution(['abc', 'def', 'ghi'], 2),
      allUserAnswers: [
        ValueNotifier(UserAnswer.start().add('abc', true)),
        ValueNotifier(UserAnswer.start().add('abc', true).add('def', true)),
        ValueNotifier(UserAnswer.start()
            .add('abc', true)
            .add('def', true)
            .add('aaa', false)),
        ValueNotifier(UserAnswer.start()
            .add('abc', true)
            .add('def', true)
            .add('aaa', false)
            .add('ghi', true)),
      ],
    );

    expect(info.playersFoundCount(), [1, 2, 2, 3]);
  });

  test('found words current user', (){
    GameInfo info = GameInfo(
      parameters: null,
      currentPlayer: 0,
      board: null,
      solution: createMockSolution(['abc', 'def', 'ghi'], 2),
      allUserAnswers: [
        ValueNotifier(UserAnswer.start().add('abc', true)),
      ],
    );

    expect(info.currentPlayerFoundCount(), 1);
  });
}
