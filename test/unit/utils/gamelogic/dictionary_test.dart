// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:bnoggles/utils/gamelogic/dictionary.dart';

void main() {
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

  test('random word', () {
    Dictionary dict = Dictionary(['1', '22', '333', '55555']);

    expect(dict.randomWord(1), '1');
    expect(dict.randomWord(2), '22');
    expect(dict.randomWord(3), '333');
    expect(dict.randomWord(5), '55555');
  });

  test('random word for wrong length', () {
    Dictionary dict = Dictionary(['1', '22', '333', '55555']);

    expect(() => dict.randomWord(4), throwsArgumentError);
  });
}
