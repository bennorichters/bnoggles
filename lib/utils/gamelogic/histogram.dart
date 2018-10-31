import 'package:collection/collection.dart';

const _eq = const ListEquality<int>();

class Histogram {
  final List<int> _occurrences;

  Histogram.fromStrings(Iterable<String> words) : this._(_toList(words));

  Histogram._(this._occurrences);

  static List<int> _toList(Iterable<String> words) {
    if (words.isEmpty) return const <int>[];
    var max = 0;
    words.map((w) => w.length).forEach((i) {
      if (i > max) max = i;
    });
    var list = List.filled(max, 0);
    words.map((w) => w.length).forEach((i) {
      if (i > 0) list[i - 1]++;
    });
    return list;
  }

  int get longest => _occurrences.length;

  bool get isEmpty => _occurrences.length == 0;

  int get count => atLeast(0);

  int operator [](int i) {
    if (i == 0) return 0;
    var index = i - 1;
    if (index >= _occurrences.length) return 0;
    return _occurrences[index];
  }

  int atLeast(int i) {
    var start = i - 1;
    if (i == 0) start = 0;
    var result = 0;
    for (var j = start; j < _occurrences.length; j++) {
      result += _occurrences[j];
    }
    return result;
  }

  @override
  bool operator ==(dynamic other) =>
      other is Histogram && _eq.equals(_occurrences, other._occurrences);

  @override
  int get hashCode => _eq.hash(_occurrences);

  @override
  String toString() => _occurrences.toString();

  Histogram operator -(Histogram other) {
    if (other.longest > longest) throw ArgumentError('$this - $other < 0');

    var buffer = List.of(_occurrences, growable: true);
    var lastNonZero = -1;
    for (var i = 0; i < other._occurrences.length; i++) {
      buffer[i] -= other._occurrences[i];
      if (buffer[i] < 0) throw ArgumentError('$this - $other < 0');

      if (buffer[i] != 0) {
        lastNonZero = i;
      }
    }
    if (other.longest == longest) {
      buffer.length = lastNonZero + 1;
    }
    return Histogram._(buffer);
  }
}
