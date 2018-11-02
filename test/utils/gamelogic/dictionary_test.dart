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
        new Dictionary(['boomgroepen', 'dorpen', 'geknotte', 'torens']);

    expect(true, dict.getInfo('boomgroepen').found);
    expect(false, dict.getInfo('boomgroep').found);
    expect(true, dict.getInfo('boomgroep').canStartWith);

    expect(false, dict.getInfo('kerken').found);
    expect(false, dict.getInfo('kerken').canStartWith);

    expect(false, dict.getInfo('verspreid').found);
    expect(false, dict.getInfo('verspreid').canStartWith);

    expect(false, dict.getInfo('aan').found);
    expect(false, dict.getInfo('aan').canStartWith);
  });
}
