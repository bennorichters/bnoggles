import 'dart:io';

main(List<String> arguments) {
  Affix pa = Prefix("aan");
  Affix pb = Prefix("af");

  Affix Sa = Suffix(2, "ze");
  Affix Sb = Suffix(0, "d");
  Affix Sc = Suffix(1, "s");

  var c = AffixedWordContainer("hoed", [pa, pb], [Sa, Sb, Sc]);

  for (int i = 0; i < c.length; i++) {
    print("$i - ${c.word(i)}");
  }
}

process() async {
  var affFile = File('D:/dev/Dutch.aff');
  var aff = await affFile.readAsLines();
}

abstract class Affix {
  String apply(String text);
}

class Prefix implements Affix {
  final String _toAdd;

  Prefix(this._toAdd);

  @override
  String apply(String text) => _toAdd + text;
}

class Suffix implements Affix {
  final int _toStrip;
  final String _toAdd;

  Suffix(this._toStrip, this._toAdd);

  @override
  String apply(String text) =>
      text.substring(0, text.length - _toStrip) + _toAdd;
}

class AffixedWordContainer {
  final String _base;
  final List<Affix> _prefixes;
  final List<Affix> _suffixes;

  AffixedWordContainer(this._base, this._prefixes, this._suffixes);

  int get length => (_prefixes.length + 1) * (_suffixes.length + 1);

  String word(int index) {
    int rowLength = _prefixes.length + 1;
    int y = (index / rowLength).floor();
    int x = index - y * rowLength;

    print("$index, $x, $y");

    String result = _base;
    if (x > 0) {
      result = _prefixes[x - 1].apply(result);
    }
    if (y > 0) {
      result = _suffixes[y - 1].apply(result);
    }

    return result;
  }
}

class AffixedWord implements Comparable<AffixedWord> {
  final AffixedWordContainer _container;
  final int _index;

  AffixedWord(this._container, this._index);

  @override
  int compareTo(AffixedWord other) =>
      _container.word(_index).compareTo(other._container.word(other._index));

  @override
  toString() => _container.word(_index);
}
