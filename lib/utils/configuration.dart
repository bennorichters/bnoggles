import 'package:bnoggles/utils/gamelogic/dictionary.dart';
import 'package:bnoggles/utils/preferences.dart';

class Configuration {
  final RandomLetterGenerator generator;
  final Dictionary dictionary;
  final Preferences preferences;

  Configuration(this.generator, this.dictionary, this.preferences);
}