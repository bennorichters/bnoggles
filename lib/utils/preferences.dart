// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The preferences as set by the user.
class Preferences {
  Preferences._({
    @required this.language,
    @required this.hasTimeLimit,
    @required this.time,
    @required this.boardWidth,
    @required this.minimalWordLength,
    @required this.hints,
  });

  /// The code of the language in which the game is played.
  final ValueNotifier<int> language;

  /// Flag for having a limited time for the game
  final ValueNotifier<bool> hasTimeLimit;

  /// The time in seconds the game will last
  final ValueNotifier<int> time;

  /// The width of the [Board]
  final ValueNotifier<int> boardWidth;

  /// The minimal length of the words to be found
  final ValueNotifier<int> minimalWordLength;

  /// Flag whether or not hints are shown
  final ValueNotifier<bool> hints;

  /// Returns the Preferences.
  ///
  /// The previous set preferences are restored from the [SharedPreferences].
  static Future<Preferences> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ValueNotifier<int> intNotifier(String name, int defaultValue) {
      var value = prefs.getInt(name) ?? defaultValue;
      var result = ValueNotifier(value);
      result.addListener(() => prefs.setInt(name, result.value));
      return result;
    }

    ValueNotifier<bool> boolNotifier(String name, bool defaultValue) {
      var value = prefs.getBool(name) ?? defaultValue;
      var result = ValueNotifier(value);
      result.addListener(() => prefs.setBool(name, result.value));
      return result;
    }

    return Preferences._(
      language: intNotifier('language', 0),
      hasTimeLimit: boolNotifier('hasTimeLimit', true),
      time: intNotifier('time', 150),
      boardWidth: intNotifier('size', 3),
      minimalWordLength: intNotifier('length', 2),
      hints: boolNotifier('hints', false),
    );
  }

  /// Creates [GameParameters] based on these Preferences
  GameParameters toParameters() => GameParameters._(
        languageCode: const ['nl', 'en', 'hu'][language.value],
        hasTimeLimit: hasTimeLimit.value,
        time: time.value,
        boardWidth: boardWidth.value,
        minimalWordLength: minimalWordLength.value,
        hints: hints.value,
      );

  @override
  String toString() =>
      'Preferences [${language.value}, ${time.value}, ${boardWidth.value}, '
      '${minimalWordLength.value}, ${hints.value}]';
}

/// Parameters to start a new game with
class GameParameters {
  const GameParameters._({
    @required this.languageCode,
    @required this.hasTimeLimit,
    @required this.time,
    @required this.boardWidth,
    @required this.minimalWordLength,
    @required this.hints,
  });

  /// The code of the language in which the game is played.
  final String languageCode;

  /// Flag for having a limited time for the game
  final bool hasTimeLimit;

  /// The time in seconds the game will last
  final int time;

  /// The width of the [Board]
  final int boardWidth;

  /// The minimal length of the words to be found
  final int minimalWordLength;

  /// Flag whether or not hints are shown
  final bool hints;
}

/// Provider for [GameParameters]
typedef GameParameters ParameterProvider();
