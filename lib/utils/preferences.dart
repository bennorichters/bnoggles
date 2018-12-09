// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The preferences as set by the user.
class Preferences {
  Preferences._(
    this.language,
    this.time,
    this.boardWidth,
    this.minimalWordLength, {
    ValueNotifier<bool> hints,
  }) : this.hints = hints ?? ValueNotifier(false);

  /// The code of the language in which the game is played.
  final ValueNotifier<int> language;

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
      intNotifier('language', 0),
      intNotifier('time', 150),
      intNotifier('size', 3),
      intNotifier('length', 2),
      hints: boolNotifier('hints', false),
    );
  }

  /// Creates [GameParameters] based on these Preferences
  GameParameters toParameters() => GameParameters(
        languageCode: const ['nl', 'en', 'hu'][language.value],
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
  /// Creates an instance of [GameParameters]
  const GameParameters({
    this.languageCode,
    this.time,
    this.boardWidth,
    this.minimalWordLength,
    this.hints,
  });

  /// The code of the language in which the game is played.
  final String languageCode;

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
