import 'package:test/test.dart';

void main() {
  test('SuffixCondition', () {
    RegExp r = RegExp("[^ab]c\$");


    print(r.hasMatch("testac"));
    print(r.hasMatch("testbc"));
    print(r.hasMatch("testcc"));
    print(r.hasMatch("testccd"));

  });
}