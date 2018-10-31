import 'dart:async';
import 'dart:io';

import '../dictionary.dart';

import 'process_aff.dart';

void main(List<String> arguments) async {
  processDic();
}

void processDic() async {
  List<String> words = await readFile();

  List<Map<String, Set<Affix>>> affixes = await processAff();
  Map<String, Set<Affix>> prefixes = affixes[0];
  Map<String, Set<Affix>> suffixes = affixes[1];

  _DictInterpreter dict = _DictInterpreter(words, prefixes, suffixes);
  dict.process();

  writeAll(dict.result);
}

void writeAll(Set<AffixedWordContainer> containers) async {
  List<AffixedWord> all = [];
  for (var container in containers) {
    for (int i = 0; i < container.length; i++) {
      all.add(AffixedWord(container, i));
    }
  }

  all.sort();

  var output = File('assets/nl/words.txt');
  var sink = output.openWrite();

  all.forEach(sink.writeln);

  await sink.flush();
  sink.close();

  print('ready');
}

Future<List<String>> readFile() async {
  var input = File('tools/nl/assets/index_nl_clean.dic');
  var contents = await input.readAsLines();
  return contents;
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
