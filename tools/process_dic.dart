import 'dart:async';
import 'dart:io';

import 'dictionary.dart';

main(List<String> arguments) {
  process();
}

process() async {
  List<String> words = await readFile();

}

Future<List<String>> readFile() async {
  var input = File('assets/index_nl_clean.dic');
  var contents = await input.readAsLines();
  return contents;
}