// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:trotter/trotter.dart';

void main(List<String> arguments) async {
   countFrequencies();
}

void countFrequencies() async {
  List<String> list = await readFile();
  String words = list.where((w) => w.length <= 3).join('/');

  var map = _FrequencyCounter(words).countAllSequences();
  (map.keys.toList()
        ..sort((a, b) => (map[b] - map[a])))
      .forEach((k) => print('"$k": ${map[k]},'));
}

class _FrequencyCounter {
  static final List<String> bag =
      characters("abcdefghijklmnopqrstuvwxyzöüóőúéáűí");

  final String _source;
  final Map<String, int> _sequenceCount = {};

  _FrequencyCounter(this._source);

  Map<String, int> countAllSequences() {
    var combos = Amalgams(1, _FrequencyCounter.bag);
    for (var combo in combos()) {
      String sequence = combo.reduce((a, b) => (a as String) + (b as String));
      _sequenceCount[sequence] = count(sequence);
    }

    return _sequenceCount;
  }

  int count(String sequence) => RegExp(sequence).allMatches(_source).length;
}

Future<List<String>> readFile() async {
  var input = File('assets/lang/hu/words.dic');
  var contents = await input.readAsLines();
  return contents;
}
