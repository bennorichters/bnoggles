// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

const String allowedChars = "abcdefghijklmnopqrstuvwxyz";
const Map<String, String> replacements = {
};

const List<String> forbiddenCodes = [];

Set<String> disallowed = Set();

void main(List<String> arguments) async {
  process();
}

void process() async {
  List<String> contents = await linesFromFile('tools/en/assets/index.dic');
  List<String> twoCharWords =
      await linesFromFile('tools/en/assets/twoletterwords.txt');
  List<String> threeCharWords =
      await linesFromFile('tools/en/assets/threeletterwords.txt');

  List<String> extraWords = await linesFromFile('tools/en/assets/extraWords.txt');

  List<String> twoThreeCharWords = List.from(twoCharWords)
    ..addAll(threeCharWords);

  contents..addAll(twoThreeCharWords)..addAll(extraWords);

  Map<String, String> result = Map();
  for (var line in contents) {
    var parts = line.split('/');
    String word = clean(parts[0]);
    String code = (parts.length > 1) ? parts[1] : '';

    if (isCodeAllowed(code) && (isWordAllowed(word, twoThreeCharWords))) {
      if (!result.containsKey(word)) {
        result[word] = code;
      }
    }
  }

  print(result.keys.length);

  var output = File('tools/en/assets/index_clean.dic');
  var sink = output.openWrite();

  for (String word in result.keys.toList()..sort()) {
    sink.writeln(word + '/' + result[word]);
  }

  await sink.flush();
  sink.close();
}

Future<List<String>> linesFromFile(String name) async {
  var input = File(name);
  var contents = await input.readAsLines();
  return contents;
}

bool isWordAllowed(String word, List<String> twoThreeCharWords) {
  if (word.length < 2) return false;

  if (word.toLowerCase() != word) return false;

  if (word.length >= 2 && word.length <= 3 && !twoThreeCharWords.contains(word))
    return false;

  for (int i = 0; i < word.length; i++) {
    var char = word.substring(i, i + 1);
    if (!allowedChars.contains(char)) {
      if (disallowed.add(char)) {
        print('$char - $word');
      }

      return false;
    }
  }

  return true;
}

bool isCodeAllowed(String code) => !forbiddenCodes.contains(code);

String clean(String word) {
  String result = word;
  for (String toReplace in replacements.keys) {
    result = result.replaceAll(toReplace, replacements[toReplace]);
  }

  return result;
}
