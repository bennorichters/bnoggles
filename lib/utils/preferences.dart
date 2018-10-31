import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  final ValueNotifier<int> language;
  final ValueNotifier<int> time;
  final ValueNotifier<int> size;
  final ValueNotifier<int> length;
  final ValueNotifier<bool> hints;

  Preferences(this.language, this.time, this.size, this.length,
      {ValueNotifier<bool> hints})
      : this.hints = hints ?? ValueNotifier(false);

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

    return Preferences(
      intNotifier('language', 0),
      intNotifier('time', 150),
      intNotifier('size', 3),
      intNotifier('length', 2),
      hints: boolNotifier('hints', false),
    );
  }

  GameParameters toParameters() => GameParameters(
        languageCode: const ['nl', 'en'][language.value],
        time: time.value,
        size: size.value,
        length: length.value,
        hints: hints.value,
      );
}

class GameParameters {
  final String languageCode;
  final int time;
  final int size;
  final int length;
  final bool hints;

  const GameParameters({this.languageCode, this.time, this.size, this.length, this.hints});
}

typedef GameParameters ParameterProvider();
