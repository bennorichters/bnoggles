// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:bnoggles/utils/preferences.dart';
import 'package:flutter/services.dart';

void main() {
  test('default values', () async {
    Preferences preferences = await getPreferences();
    expect(preferences.language.value, 0);
    expect(preferences.hasTimeLimit.value, true);
    expect(preferences.time.value, 150);
    expect(preferences.boardWidth.value, 3);
    expect(preferences.minimalWordLength.value, 2);
    expect(preferences.hints.value, false);
  });

  test('GameParameters created by Preferences', () async {
    Preferences preferences = await getPreferences();
    GameParameters gp = preferences.toParameters();
    expect(gp.languageCode, 'nl');
    expect(gp.hasTimeLimit, true);
    expect(gp.time, 150);
    expect(gp.boardWidth, 3);
    expect(gp.minimalWordLength, 2);
    expect(gp.hints, false);
  });

  test('toString does not throw exception', () async {
    Preferences preferences = await getPreferences();
    preferences.toString();
  });
}

Future<Preferences> getPreferences() async {
  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      // Initial values can be set here. At the moment of writing they need to
      // be prefixed with the undocumented prefix 'flutter.'; for example:
      // return <String, dynamic>{'flutter.language': 1};

      return <String, dynamic>{};
    }
    return null;
  });

  Preferences preferences = await Preferences.load();
  return preferences;
}