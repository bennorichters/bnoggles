import 'package:test/test.dart';

import 'package:bnoggles/utils/dictionary.dart';

void main() {
  test('RandomLetterGenerator', () {
    var rlg = RandomLetterGenerator({'a': 1});
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
