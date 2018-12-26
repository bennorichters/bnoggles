// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/utils/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show DeviceOrientation, SystemChrome, rootBundle;

import 'package:bnoggles/screens/settings/settings_screen.dart';
import 'package:bnoggles/utils/preferences.dart';

void main() async {
  Language.registerLoader(LanguageLoader(
    characterSequenceFrequencies: (code) =>
        rootBundle.loadString('assets/lang/$code/letterFrequencies.json'),
    availableWords: (code) =>
        rootBundle.loadString('assets/lang/$code/words.dic'),
  ));

  var preferences = await Preferences.load();

  // preload previous language
  // Language.forLanguageCode(preferences.toParameters().languageCode);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(Bnoggles(preferences));
  });
}

/// The main class for the app.
///
/// An instance of this class is passed into Flutter's [runApp] method.
class Bnoggles extends StatelessWidget {
  /// Creates an instance of [Bnoggles]
  ///
  /// [preferences] is used to set and save user settings.
  Bnoggles(this.preferences);

  final Preferences preferences;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bnoggles',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SettingsScreen(preferences: preferences),
    );
  }
}
