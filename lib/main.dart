import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:bnoggles/screens/start/start_screen.dart';

import 'package:bnoggles/utils/dictionary.dart';

void main() async {
  var res = await setup();

  runApp(MyApp(res[0], res[1]));
}

setup() async {
  String configJson = await loadConfigJson();
  var config = json.decode(configJson);

  Map<String, int> _freq = getFreq(config);
  var generator = RandomLetterGenerator(_freq);

  String words = await loadDictionary();
  Dictionary dict = Dictionary(words.split("\n")..sort());

  return [generator, dict];
}

Map<String, int> getFreq(var config) {
  Map<String, int> result = Map();
  Map<String, dynamic> m = config['letterFrequencies'];
  m.forEach((k, e) => result[k] = e);

  return result;
}

Future<String> loadConfigJson() async {
  return await rootBundle.loadString('assets/config.json');
}

Future<String> loadDictionary() async {
  return await rootBundle.loadString('assets/words_nl.txt');
}

Future<Dictionary> readDutchWords(String fileName) async {
  var source = File(fileName);
  List<String> contents = await source.readAsLines();
  contents.sort();
  return Dictionary(contents);
}

class MyApp extends StatelessWidget {

  final RandomLetterGenerator generator;
  final Dictionary dictionary;

  MyApp(this.generator, this.dictionary);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StartScreen(dictionary: dictionary, generator: generator),
    );
  }
}
