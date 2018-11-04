// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:io';

import '../dictionary.dart';

import 'process_aff.dart';
import 'read_file.dart';

void main(List<String> arguments) async {
  processDic();
}

void processDic() async {
  List<String> words =
      await linesFromFile('tools/nl/assets/index_nl_clean.dic');

  List<Map<String, Set<Affix>>> affixes = await processAff();
  Map<String, Set<Affix>> prefixes = affixes[0];
  Map<String, Set<Affix>> suffixes = affixes[1];

  _DictInterpreter dict = _DictInterpreter(words, prefixes, suffixes);
  dict.process();

  writeAll(dict.result);
}

void writeAll(Set<AffixedWordContainer> containers) async {
  List<String> all = [];
  for (var container in containers) {
    for (int i = 0; i < container.length; i++) {
      all.add(AffixedWord(container, i).toString());
    }
  }

  await addTwoThreeLetterWords(all);

  all.sort();

  var output = File('assets/lang/nl/words.dic');
  var sink = output.openWrite();

  all.forEach(sink.writeln);

  await sink.flush();
  sink.close();

  print('ready');
}

Future<void> addTwoThreeLetterWords(List<String> all) async {
  List<String> twoCharWords =
      await linesFromFile('tools/nl/assets/tweeletterwoorden.txt');
  List<String> threeCharWords =
      await linesFromFile('tools/nl/assets/drieletterwoorden.txt');

  all.addAll(twoCharWords);
  all.addAll(threeCharWords);
}

class _DictInterpreter {
  final List<String> _lines;
  final Map<String, Set<Affix>> _prefixes;
  final Map<String, Set<Affix>> _suffixes;

  final Set<AffixedWordContainer> result = Set();

  _DictInterpreter(this._lines, this._prefixes, this._suffixes);

  void process() {
    _lines.forEach((e) => result.add(parseLine(e)));
  }

  AffixedWordContainer parseLine(String line) {
    var elements = line.split("/");
    String word = elements[0];
    String affixNames = elements[1];

    List<Affix> prefixes = findAffixes(word, affixNames, _prefixes);
    List<Affix> suffixes = findAffixes(word, affixNames, _suffixes);

    return AffixedWordContainer(word, prefixes, suffixes);
  }

  List<Affix> findAffixes(
      String word, String affixNames, Map<String, Set<Affix>> affixes) {
    List<Affix> result = [];
    for (int i = 0; i < affixNames.length; i += 2) {
      String name = affixNames.substring(i, i + 2);
      if (affixes.containsKey(name)) {
        result.addAll(
            affixes[name].where((a) => a.canBeAppliedTo(word)).toList());
      }
    }

    return result;
  }
}
