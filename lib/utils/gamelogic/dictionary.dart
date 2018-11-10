// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:collection/collection.dart';

/// A list of valid words.
class Dictionary {
  final List<String> _words;

  /// Creates a dictionary with the given [words].
  Dictionary(this._words);

  /// Looks up [word] in this dictionary and returns information about it.
  WordInfo getInfo(String word) {
    int index = lowerBound(_words, word);

    if (index == _words.length) return _notFoundDeadEnd;

    String higher = _words[index];
    if (higher == word) return _found;
    if (higher.startsWith(word)) return _notFoundCanStart;
    return _notFoundDeadEnd;
  }

  /// Returns a random word with the given [length]. If the dictionary does not
  /// contain a word with the given an [ArgumentError] will be thrown.
  String randomWord(int length) =>
      (_words.where((w) => w.length == length).toList()..shuffle()).firstWhere(
          (w) => true,
          orElse: () => throw ArgumentError('no word for length $length'));
}

/// Information about a word
class WordInfo {
  /// [true] if this word is in the [Dictionary], [false] otherwise.
  final bool found;

  /// [true] if there is at least one word in the [Dictionary] that starts with
  /// the word, [false] otherwise. If [found] is [true], [canStartWith] is also
  /// [true].
  final bool canStartWith;

  const WordInfo._(this.found, this.canStartWith);
}

const WordInfo _notFoundDeadEnd = WordInfo._(false, false);
const WordInfo _notFoundCanStart = WordInfo._(false, true);
const WordInfo _found = WordInfo._(true, true);
