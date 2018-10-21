import 'dart:async';
import 'dart:io';

import 'dictionary.dart';

main(List<String> arguments) {
  process();
}

process() async {
  List<String> contents = await readFile();

  var interpreter = _AffixInterpreter(contents.iterator);
  interpreter.process();

  print(interpreter._prefixes);

  return [interpreter._prefixes, interpreter._suffixes];
}

Future<List<String>> readFile() async {
  var input = File('assets/index_nl.aff');
  var contents = await input.readAsLines();
  return contents;
}

class _AffixInterpreter {
  final Iterator<String> _lines;

  final Map<AffixCategory, List<Affix>> _prefixes = Map();
  final Map<AffixCategory, List<Affix>> _suffixes = Map();

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

      var toRemove = elements[2];
      var toAdd = elements[3];

      if (!isProperNameAffix(name) && !isContinuationAffix(toAdd)) {
        var condition = elements.length >= 5 ? elements[4] : "";
        affixAdder(name, toRemove, toAdd, condition);
      }
    }
  }

  bool isProperNameAffix(String name) => ['PN', 'PI', 'PJ'].contains(name);

  bool isContinuationAffix(String toAdd) => toAdd.contains("/");

  void startPrefix(String header) {
    prefixAdder(String name, String toRemove, String toAdd, String condition) {
      assert(toRemove == "0", "expected 0 for remove option in prefix");
      assert(condition.isEmpty || condition == '.',
          'expected no condition for prefix. $condition');

      var cat = AffixCategory(name, "");
      _prefixes.putIfAbsent(cat, () => []).add(Prefix(toAdd));
    }

    parseAffixLines(header, prefixAdder);
  }

  void startSuffix(String header) {
    suffixAdder(String name, String toRemove, String toAdd, String condition) {
      var cat = AffixCategory(name, condition);
      _suffixes.putIfAbsent(cat, () => []).add(Suffix(toAdd, toRemove.length));
    }

    parseAffixLines(header, suffixAdder);
  }
}
