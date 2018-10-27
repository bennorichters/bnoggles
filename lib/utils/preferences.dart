import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  final ValueNotifier<int> time;
  final ValueNotifier<int> size;
  final ValueNotifier<int> length;

  Preferences(this.time, this.size, this.length);

  static Future<Preferences> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ValueNotifier<int> notifier(String name, int defaultValue) {
      var value = prefs.getInt(name) ?? defaultValue;
      var result = ValueNotifier(value);
      result.addListener(() => prefs.setInt(name, result.value));
      return result;
    }

    return Preferences(
      notifier('time', 150),
      notifier('size', 3),
      notifier('length', 2),
    );
  }
}
