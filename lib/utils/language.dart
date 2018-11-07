// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:convert';
import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/gamelogic/game.dart';
import 'package:bnoggles/utils/gamelogic/lettter_frequency.dart';

class Language {
  static LanguageLoader _loader;
  static String _currentCode;
  static Language _currentLanguage;

  LetterFrequencyInfo _frequencyInfo;
  Dictionary _dictionary;

  Language._(this._frequencyInfo, this._dictionary);

  static void registerLoader(LanguageLoader loader) => _loader = loader;

  static Future<Language> forLanguageCode(String code) async {
    if (_currentCode == code) {
      return _currentLanguage;
    }
    return _load(code).then((language) {
      _currentCode = code;
      _currentLanguage = language;
      return language;
    });
  }

  static Future<Language> _load(String code) async {
    var start = DateTime.now();
    return Future.wait<String>([
      _loader.letterFrequencies(code),
      _loader.availableWords(code),
    ]).then((var files) {
      return Language._(
        LetterFrequencyInfo(_getFrequencies(files[0])),
        Dictionary(files[1].split("\n")..sort()),
      );
    }).then((Language language) {
      var time = DateTime.now().difference(start).inMilliseconds;
      print("Loading '$code' took ${time}ms");
      return language;
    });
  }

  static Map<String, int> _getFrequencies(String frequencies) {
    var result = <String, int>{};
    Map<String, dynamic> m = json.decode(frequencies);
    m.forEach((k, dynamic e) => result[k] = e as int);
    return result;
  }

  Game createGame(int boardSize, int minimalWordLength) => Game(
        boardSize,
        LetterGenerator(_frequencyInfo),
        _dictionary,
        minimalWordLength,
      );
}

class LanguageLoader {
  Resolver letterFrequencies;
  Resolver availableWords;

  LanguageLoader({this.letterFrequencies, this.availableWords});
}

typedef Future<String> Resolver(String languageCode);
