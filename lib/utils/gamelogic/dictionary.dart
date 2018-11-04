// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

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

  const WordInfo._(this.found, this.canStartWith);
}

const WordInfo _notFoundDeadEnd = WordInfo._(false, false);
const WordInfo _notFoundCanStart = WordInfo._(false, true);
const WordInfo _found = WordInfo._(true, true);

