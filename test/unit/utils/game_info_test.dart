// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.
import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/frequency.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';
import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';

import 'package:bnoggles/utils/game_info.dart';
import 'package:test/test.dart';

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
      board: mockBoard,
      solution: mockSolution,
      userAnswer: vua,
    );

    expect(info.parameters, mockParameters);
    expect(info.board, mockBoard);
    expect(info.solution, mockSolution);
    expect(info.userAnswer, vua);
  });

  test('randomWords', () async {
    var words = ['abc', 'def', 'ghi'];
    Frequency frequency = Frequency.fromStrings(words);
    MockSolution mockSolution = MockSolution();

    when(mockSolution.frequency).thenReturn(frequency);
    when(mockSolution.uniqueWords()).thenReturn(words.toSet());

    ValueNotifier<UserAnswer> vua = ValueNotifier(UserAnswer.start());

    GameInfo info = GameInfo(
      parameters: null,
      board: null,
      solution: mockSolution,
      userAnswer: vua,
    );

    expect(info.randomWords.toList()..sort(), words);
  });

  test('scoreSheet', () async {
    var words = ['abc', 'def', 'ghi'];
    Frequency frequency = Frequency.fromStrings(words);
    MockSolution mockSolution = MockSolution();

    when(mockSolution.frequency).thenReturn(frequency);
    when(mockSolution.uniqueWords()).thenReturn(words.toSet());

    ValueNotifier<UserAnswer> vua =
        ValueNotifier(UserAnswer(UserAnswer.start(), 'abc', true));

    GameInfo info = GameInfo(
      parameters: null,
      board: null,
      solution: mockSolution,
      userAnswer: vua,
    );

    expect(info.scoreSheet.availableWords, 3);
    expect(info.scoreSheet.foundWords, 1);
  });

  test('answer listeners', () async {
    var words = ['abc', 'def', 'ghi'];
    Frequency frequency = Frequency.fromStrings(words);
    MockSolution mockSolution = MockSolution();

    when(mockSolution.frequency).thenReturn(frequency);
    when(mockSolution.uniqueWords()).thenReturn(words.toSet());

    ValueNotifier<UserAnswer> vua =
        ValueNotifier(UserAnswer(UserAnswer.start(), 'abc', true));

    GameInfo info = GameInfo(
      parameters: null,
      board: null,
      solution: mockSolution,
      userAnswer: vua,
    );

    var flag = false;
    void toggleFlag() {
      flag = !flag;
    }

    info.addUserAnswerListener(toggleFlag);
    vua.value = UserAnswer(vua.value, 'd', false);
    expect(flag, true);

    info.removeUserAnswerListener(toggleFlag);
    vua.value = UserAnswer(vua.value, 'e', false);
    expect(flag, true);
  });
}
