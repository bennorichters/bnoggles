import 'dart:convert';
import 'package:bnoggles/utils/gamelogic/board.dart';
import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/gamelogic/solution.dart';

class Language {
  static LanguageLoader _loader;
  static String _currentCode;
  static Language _currentLanguage;

  RandomLetterGenerator _generator;
  Dictionary _dictionary;

  Language._(this._generator, this._dictionary);

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
        RandomLetterGenerator(_getFrequencies(files[0])),
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

  Board generateBoard(int size) => Board(
        size,
        _generator,
      );

  Solution solve(Board board, int minimalWordLength) => Solution(
        board,
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
