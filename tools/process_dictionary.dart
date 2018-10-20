import 'dart:io';

const String allowedChars = "abcdefghijklmnopqrstuvwxyz";
const replacements = {
  "'": "",
  '-': '',
  'ë': 'e',
  'é': 'e',
  'ê': 'e',
  'ĳ': 'ij',
  'ï': 'i',
  'è': 'e',
  'ç': 'c',
  'ü': 'u',
  'ö': 'o',
  'ñ': 'n',
  'à': 'a',
  'û': 'u',
  'ô': 'o',
  'ä': 'a',
  'î': 'i',
  'ó': 'o',
  'ú': 'u',
  'á': 'a',
  'í': 'i',
  'â': 'a',
  'å': 'a',
};

const forbiddenCodes = ['PN', 'Fw'];

Set<String> disallowed = Set();

main(List<String> arguments) {
  process();
}

process() async {
  var input = File('assets/index_nl.dic');
  var contents = await input.readAsLines();

  Map<String, String> result = Map();
  for (var line in contents) {
    var parts = line.split('/');
    String word = parts[0].toLowerCase();
    String code = (parts.length > 1) ? parts[1] : '';

    if (isCodeAllowed(code) && (isWordAllowed(word))) {
      String fixed = fixWord(word);
      if (!result.containsKey(fixed)) {
        result[fixed] = code;
      }
    }
  }

  print(result.keys.length);

  var output = File('assets/index_nl_clean.dic');
  var sink = output.openWrite();

  for (String word in result.keys.toList()..sort()) {
    sink.writeln(word + '/' + result[word]);
  }

  await sink.flush();
  sink.close();
}

bool isWordAllowed(String word) {
  for (int i = 0; i < word.length; i++) {
    var char = word.substring(i, i + 1);
    if (!allowedChars.contains(char) && !replacements.keys.contains(char)) {
      if (disallowed.add(char)) {
        print('$char - $word');
      }

      return false;
    }
  }

  return true;
}

bool isCodeAllowed(String code) {
  return !forbiddenCodes.contains(code);
}

String fixWord(String word) {
  String result = word;
  for (String toReplace in replacements.keys) {
    result = result.replaceAll(toReplace, replacements[toReplace]);
  }

  return result;
}
