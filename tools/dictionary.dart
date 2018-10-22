import 'package:quiver/core.dart';

abstract class Affix {
  final String _toAdd;

  Affix(this._toAdd);

  bool canBeAppliedTo(String word);

  String apply(String word);
}

class Prefix extends Affix {
  Prefix(String toAdd) : super(toAdd);

  @override
  String apply(String text) => _toAdd + text;

  @override
  bool canBeAppliedTo(String word) => true;

  @override
  bool operator ==(other) => other is Prefix && other._toAdd == _toAdd;

  @override
  int get hashCode => _toAdd.hashCode;

  @override
  String toString() => "PFX $_toAdd";
}

class Suffix extends Affix {
  final int _toStrip;
  final SuffixCondition _condition;

  Suffix(toAdd, this._toStrip, this._condition) : super(toAdd);

  @override
  bool canBeAppliedTo(String word) => _condition.match(word);

  @override
  String apply(String text) =>
      text.substring(0, text.length - _toStrip) + _toAdd;

  @override
  bool operator ==(other) =>
      other is Suffix &&
      other._toAdd == _toAdd &&
      other._toStrip == _toStrip &&
      other._condition == _condition;

  @override
  int get hashCode =>
      hash3(_toAdd.hashCode, _toStrip.hashCode, _condition.hashCode);

  @override
  String toString() => "SFX $_toAdd $_toStrip $_condition";
}

class SuffixCondition {
  final String _toMatch;
  final bool _negated;

  const SuffixCondition(this._toMatch, this._negated);

  match(String word) {
    var endsWith = word.endsWith(_toMatch);
    return (_negated) ? !endsWith : endsWith;
  }

  @override
  bool operator ==(other) =>
      other is SuffixCondition &&
          other._toMatch == _toMatch &&
          other._negated == _negated;

  @override
  int get hashCode =>
      hash2(_toMatch.hashCode, _negated.hashCode);

  @override
  toString() => '[$_toMatch - $_negated]';
}

const SuffixCondition emptyCondition = SuffixCondition("", false);

class AffixedWordContainer {
  final String _base;
  final List<Affix> _prefixes;
  final List<Affix> _suffixes;

  AffixedWordContainer(this._base, this._prefixes, this._suffixes);

  int get length => (_prefixes.length + 1) * (_suffixes.length + 1);

  String _word(int index) {
    int rowLength = _prefixes.length + 1;
    int y = (index / rowLength).floor();
    int x = index - y * rowLength;

    String result = _base;
    if (x > 0) {
      result = _prefixes[x - 1].apply(result);
    }
    if (y > 0) {
      result = _suffixes[y - 1].apply(result);
    }

    return result;
  }

  @override
  toString() => '$_base $_prefixes $_suffixes';
}

class AffixedWord implements Comparable<AffixedWord> {
  final AffixedWordContainer _container;
  final int _index;

  AffixedWord(this._container, this._index);

  @override
  int compareTo(AffixedWord other) =>
      _container._word(_index).compareTo(other._container._word(other._index));

  @override
  toString() => _container._word(_index);
}
