import 'dart:math';

import 'package:collection/collection.dart';

class Dictionary {
  final List<String> _words;

  Dictionary(this._words);

  WordInfo getInfo(String word) {
    int index = lowerBound(_words, word);

    if (index == _words.length) return _notFoundDeadEnd;

    String higher = _words[index];
    if (higher == word) return _found;
    if (higher.startsWith(word)) return _notFoundCanStart;
    return _notFoundDeadEnd;
  }

  String randomWord(int length) =>
      (_words.where((w) => w.length == length).toList()..shuffle())[0];
}

class WordInfo {
  final bool found;
  final bool canStartWith;

  const WordInfo._create(this.found, this.canStartWith);
}

const WordInfo _notFoundDeadEnd = WordInfo._create(false, false);
const WordInfo _notFoundCanStart = WordInfo._create(false, true);
const WordInfo _found = WordInfo._create(true, true);

class RandomLetterGenerator {
  final _rng = new Random();
  final Map<String, int> _frequencies;

  RandomLetterGenerator(this._frequencies);

  String next({int maxLength = 1}) {
    Map<String, int> toChooseFrom = Map.of(_frequencies);
    toChooseFrom.removeWhere((letter, freq) => letter.length > maxLength);

    var total = toChooseFrom.values.reduce((a, b) => a + b);
    var randomNumber = _rng.nextInt(total);

    var sum = 0;
    for (String c in toChooseFrom.keys.toList()..sort()) {
      sum += toChooseFrom[c];
      if (sum > randomNumber) return c;
    }

    throw StateError('should not reach this code');
  }
}

