import 'dart:async';
import 'dart:io';

import 'dictionary.dart';
import 'clean_dict_file.dart';

main(List<String> arguments) {
  processAff();
}

Future<List<Map<String, Set<Affix>>>> processAff() async {
  List<String> contents = await readFile();

  var interpreter = _AffixInterpreter(contents.iterator);
  interpreter.process();

  return [interpreter._prefixes, interpreter._suffixes];
}

Future<List<String>> readFile() async {
  var input = File('assets/index_nl.aff');
  var contents = await input.readAsLines();
  return contents;
}

class _AffixInterpreter {
  final Iterator<String> _lines;

  final Map<String, Set<Affix>> _prefixes = Map();
  final Map<String, Set<Affix>> _suffixes = Map();

  _AffixInterpreter(this._lines);

  process() {
    while (_lines.moveNext()) {
      route(_lines.current);
    }
  }

  void route(String current) {
    String line = current.trim();
    if (line.isEmpty) {
      return;
    }

    if (line.startsWith("#")) {
      return;
    }

    if (line.startsWith("PFX ")) {
      return startPrefix(line);
    }

    if (line.startsWith("SFX ")) {
      return startSuffix(line);
    }

    throw FormatException("cannot parse line '$current'");
  }

  List<String> splitLine(String line) {
    String singleSpaces = line.trim();
    while (singleSpaces.contains("  ")) {
      singleSpaces = singleSpaces.replaceAll("  ", " ");
    }

    return singleSpaces.split(" ");
  }

  parseHeader(String line) {
    var elements = splitLine(line);
    assert(elements.length == 4, "unexpected format in header '$line'");

    var type = elements[0];
    var name = elements[1];
    var combineYN = elements[2];
    assert(combineYN == 'Y' || isProperNameAffix(name),
        "expected Y in header '$line'");

    try {
      int length = int.parse(elements[3]);
      assert(length > 0, "unexpected number of lines to follow '$line'");

      return {"type": type, "name": name, "linesToFollow": length};
    } on Exception catch (e) {
      print("error parsing '$line'");
      throw e;
    }
  }

  void parseAffixLines(String header, affixAdder) {
    var headerInfo = parseHeader(header);

    for (int i = 0; i < headerInfo["linesToFollow"]; i++) {
      assert(_lines.moveNext(), "not enough lines below header '$header'");
      var elements = splitLine(_lines.current);
      assert(elements[0] == headerInfo["type"],
          "unexpected line header '$header', line ${_lines.current}");
      var name = elements[1];
      assert(name == headerInfo["name"],
          "unexpected line header '$header', line ${_lines.current}");

      var toRemove = createRemoveLength(elements[2]);
      var toAdd = clean(stripContinuation(elements[3]));

      if (!isProperNameAffix(name) && toAdd.isNotEmpty) {
        affixAdder(name, toRemove, toAdd, createCondition(elements));
      }
    }
  }

  int createRemoveLength(String element) =>
      (element == "0") ? 0 : element.length;

  SuffixCondition createCondition(List<String> elements) {
    var text = elements.length >= 5 ? clean(elements[4]) : "";
    if (text == ".") {
      return emptyCondition;
    }

    if (text.startsWith("[")) {
      text = text.substring(1, text.length - 1);
    }

    bool negated = text.startsWith("^");
    if (negated) {
      text = text.substring(1);
      assert(text.length == 1, "length negated condition not equal to 1 $text");
    }

    return SuffixCondition(text, negated);
  }

  String stripContinuation(String toAdd) => toAdd.split("/")[0];

  bool isProperNameAffix(String name) => ['PN', 'PI', 'PJ'].contains(name);

  void startPrefix(String header) {
    prefixAdder(
        String name, int toRemove, String toAdd, SuffixCondition condition) {
      assert(toRemove == 0, "expected 0 for remove option in prefix");
      assert(condition == emptyCondition,
          'expected no condition for prefix. $condition');

      _prefixes.putIfAbsent(name, () => Set()).add(Prefix(toAdd));
    }

    parseAffixLines(header, prefixAdder);
  }

  void startSuffix(String header) {
    suffixAdder(
        String name, int toRemove, String toAdd, SuffixCondition condition) {
      _suffixes
          .putIfAbsent(name, () => Set())
          .add(Suffix(toAdd, toRemove, condition));
    }

    parseAffixLines(header, suffixAdder);
  }
}
