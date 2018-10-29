import 'package:bnoggles/utils/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show DeviceOrientation, SystemChrome, rootBundle;

import 'package:bnoggles/screens/settings/settings_screen.dart';
import 'package:bnoggles/utils/preferences.dart';

void main() async {
  Language.registerLoader(LanguageLoader(
    letterFrequencies: (code) =>
        rootBundle.loadString('assets/$code/letterFrequencies.json'),
    availableWords: (code) => rootBundle.loadString('assets/$code/words.txt'),
  ));

  var preferences = await Preferences.load();
  // preload previous language
  Language.forLanguageCode(preferences.toParameters().languageCode);
  runApp(MyApp(preferences));
}

class MyApp extends StatelessWidget {
  final Preferences preferences;

  MyApp(this.preferences);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Bnoggles',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SettingsScreen(preferences: preferences),
    );
  }
}
