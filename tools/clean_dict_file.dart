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
  List<String> contents = await linesFromFile('tools/assets/index_nl.dic');
  List<String> twoCharWords =
      await linesFromFile('tools/assets/tweeletterwoorden.txt');
  List<String> threeCharWords =
      await linesFromFile('tools/assets/drieletterwoorden.txt');

  List<String> twoThreeCharWords = List.from(twoCharWords)
    ..addAll(threeCharWords);

  contents.addAll(twoThreeCharWords);

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

  var output = File('tools/assets/index_nl_clean.dic');
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
    if (!allowedChars.contains(char) && !replacements.keys.contains(char)) {
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
