import 'dart:async';
import 'dart:io';

import 'dictionary.dart';

import 'process_aff.dart';

main(List<String> arguments) async {

  List<Map<String, Set<Affix>>> affixes = await processAff();
  Map<String, Set<Affix>> prefixes = affixes[0];
  Map<String, Set<Affix>> suffixes = affixes[1];

  var int = DictInterpreter([], prefixes, suffixes);
  int.process();
}

processDic() async {
  List<String> words = await readFile();
}

Future<List<String>> readFile() async {
  var input = File('assets/index_nl_clean.dic');
  var contents = await input.readAsLines();
  return contents;
}

class DictInterpreter {
  final List<String> _lines;
  final Map<String, Set<Affix>> _prefixes;
  final Map<String, Set<Affix>> _suffixes;

  DictInterpreter(this._lines, this._prefixes, this._suffixes);

  process() {
    var ac = parseLine("agenda/CcCeYeZcC1");
    for (int i = 0; i < ac.length; i++) {
      print(AffixedWord(ac, i));
    }
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
        var list = affixes[name].where((a) => a.canBeAppliedTo(word)).toList();
        print(list);
        result.addAll(
            list);
      }
    }

    return result;
  }
}
