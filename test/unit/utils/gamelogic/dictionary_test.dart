// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'package:bnoggles/utils/gamelogic/dictionary.dart';

import 'package:bnoggles/utils/gamelogic/lettter_frequency.dart';

void main() {
  test('RandomLetterGenerator', () {
    var info = LetterFrequencyInfo({'a': 1});

    LetterGenerator rlg = LetterGenerator(info);

    expect(rlg.next(), 'a');
    expect(rlg.next(), 'a');
    expect(rlg.next(), 'a');
    expect(rlg.next(), 'a');
  });

  test('returned WordInfo', () {
    Dictionary dict =
        Dictionary(['boomgroepen', 'dorpen', 'geknotte', 'torens']);

    expect(dict.getInfo('boomgroepen').found, true);
    expect(dict.getInfo('boomgroep').found, false);
    expect(dict.getInfo('boomgroep').canStartWith, true);

    expect(dict.getInfo('kerken').found, false);
    expect(dict.getInfo('kerken').canStartWith, false);

    expect(dict.getInfo('verspreid').found, false);
    expect(dict.getInfo('verspreid').canStartWith, false);

    expect(dict.getInfo('aan').found, false);
    expect(dict.getInfo('aan').canStartWith, false);
  });
}
