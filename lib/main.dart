import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:bnoggles/screens/game/game_screen.dart';

import 'package:bnoggles/utils/board.dart';
import 'package:bnoggles/utils/dictionary.dart';
import 'package:bnoggles/utils/solution.dart';

Board _board;
Solution _solution;

void main() async {
  await setup();

  runApp(MyApp());
}

setup() async {
  String configJson = await loadConfigJson();
  var config = json.decode(configJson);

  Map<String, int> _freq = getFreq(config);
  var g = RandomLetterGenerator(_freq);

  String words = await loadDictionary();
  Dictionary dict = Dictionary(words.split("\n")..sort());

  _board = Board(3, g);

  _solution = Solution(_board, dict);
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GamePage(
          title: 'Flutter Demo Home Page', board: _board, solution: _solution),
    );
  }
}
