import 'package:bnoggles/utils/gamelogic/histogram.dart';
import 'package:test/test.dart';

void main() {
  test('emptyList', () {
    Histogram d = Histogram.fromStrings([]);
    expect(d.longest, 0);
    expect(d[0], 0);
    expect(d.atLeast(0), 0);
    expect(d.isEmpty, true);
  });

  test('emptyString', () {
    Histogram d = Histogram.fromStrings(['']);
    expect(d.longest, 0);
    expect(d[0], 0);
    expect(d.atLeast(0), 0);
    expect(d.isEmpty, true);
  });

  test('singleLetter', () {
    Histogram d = Histogram.fromStrings(['a']);
    expect(d.longest, 1);
    expect(d[0], 0);
    expect(d[1], 1);
    expect(d[2], 0);
    expect(d.atLeast(0), 1);
    expect(d.atLeast(1), 1);
    expect(d.atLeast(2), 0);
    expect(d.isEmpty, false);
  });

  test('isEmpty', () {
    expect(Histogram.fromStrings([]).isEmpty, true);
    expect(Histogram.fromStrings(['']).isEmpty, true);
    expect(Histogram.fromStrings(['a']).isEmpty, false);
  });

  test('atLeast', () {
    expect(Histogram.fromStrings(['a']).atLeast(0), 1);
    expect(Histogram.fromStrings(['a']).atLeast(1), 1);
    expect(Histogram.fromStrings(['a']).atLeast(2), 0);
    expect(Histogram.fromStrings(['a', 'aaa', 'aaa']).atLeast(0), 3);
    expect(Histogram.fromStrings(['a', 'aaa', 'aaa']).atLeast(1), 3);
    expect(Histogram.fromStrings(['a', 'aaa', 'aaa']).atLeast(2), 2);
    expect(Histogram.fromStrings(['a', 'aaa', 'aaa']).atLeast(3), 2);
    expect(Histogram.fromStrings(['a', 'aaa', 'aaa']).atLeast(4), 0);
  });

  test('longest', () {
    expect(Histogram.fromStrings(['']).longest, 0);
    expect(Histogram.fromStrings(['a']).longest, 1);
    expect(Histogram.fromStrings(['a', 'aaa']).longest, 3);
    expect(Histogram.fromStrings(['a', 'aaa', 'aaa']).longest, 3);
  });

  test('equals', () {
    var d = Histogram.fromStrings([]);
    expect(d == d, true);
    expect(
        Histogram.fromStrings(['']) == Histogram.fromStrings([]), true);
    expect(Histogram.fromStrings(['a']) == Histogram.fromStrings(['a']),
        true);
    expect(Histogram.fromStrings(['a']) == Histogram.fromStrings(['b']),
        true);
    expect(
        Histogram.fromStrings(['a', 'aaa']) ==
            Histogram.fromStrings(['aaa', 'a']),
        true);
    expect(
        Histogram.fromStrings(['a']) ==
            Histogram.fromStrings(['aaa', 'a']),
        false);
  });

  test('hashCode', () {
    var d = Histogram.fromStrings([]);
    expect(d.hashCode == d.hashCode, true);
    expect(
        Histogram.fromStrings(['']).hashCode ==
            Histogram.fromStrings([]).hashCode,
        true);
    expect(
        Histogram.fromStrings(['a']).hashCode ==
            Histogram.fromStrings(['a']).hashCode,
        true);
    expect(
        Histogram.fromStrings(['a']).hashCode ==
            Histogram.fromStrings(['b']).hashCode,
        true);
    expect(
        Histogram.fromStrings(['a', 'aaa']).hashCode ==
            Histogram.fromStrings(['aaa', 'a']).hashCode,
        true);
    expect(
        Histogram.fromStrings(['a']).hashCode ==
            Histogram.fromStrings(['aaa', 'a']).hashCode,
        false);
  });

  test('minus', () {
    expect(Histogram.fromStrings(['a']) - Histogram.fromStrings(['a']) , Histogram.fromStrings([]));
    expect(Histogram.fromStrings(['a']) - Histogram.fromStrings(['']) , Histogram.fromStrings(['a']));
    expect(Histogram.fromStrings(['a', 'aaa']) - Histogram.fromStrings(['a']), Histogram.fromStrings(['aaa']));
    expect(() => Histogram.fromStrings(['aaa']) - Histogram.fromStrings(['a']), throwsArgumentError);
    expect(() => Histogram.fromStrings(['a']) - Histogram.fromStrings(['a', 'a']), throwsArgumentError);
  });
}
