import 'dart:io';

main(List<String> arguments) {
  process();
}

process() async {
  List<String> original = await fileContents('assets/index_nl.dic');
//  List<String> clean = await fileContents('assets/index_nl_clean.dic');

  original
      .where((e) => !e.contains("/PN"))
      .map((e) => e.contains("/") ? e.substring(0, e.indexOf("/")) : e)
      .where((e) => e.isNotEmpty && (e.toLowerCase() != e))
      .forEach(print);
}

Future<List<String>> fileContents(String name) async {
  var file = File(name);
  return await file.readAsLines();
}
