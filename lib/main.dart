import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'provider.dart';

import 'src/board.dart';
import 'src/coordinate.dart';
import 'src/dictionary.dart';
import 'src/solution.dart';

Board _board;
Solution _solution;

class UserAnswer extends Answer {
  final String latestUserWord;
  final bool latestCorrect;
  final Set<String> found;

  UserAnswer._internal(this.latestUserWord, this.latestCorrect, this.found);

  static UserAnswer start() => UserAnswer._internal("___", false, Set());

  UserAnswer.extend(UserAnswer old, String latest, bool correct)
      : latestUserWord = latest,
        latestCorrect = correct,
        found = correct ? (Set.from(old.found)..add(latest)) : old.found;

  @override
  Set<String> uniqueWords() => found;
}

void main() async {
  await setup();

  runApp(MyApp());
}

setup() async {
  String configJson = await loadConfigJson();
  var config = json.decode(configJson);

  Map<String, int> _freq = getFreq(config);
  var g = RandomLetterGenerator(_freq);

  String words = await loadDictionary();
  Dictionary dict = Dictionary(words.split("\n")..sort());

  _board = Board(3, g);

  _solution = Solution(_board, dict);
}

Map<String, int> getFreq(var config) {
  Map<String, int> result = Map();
  Map<String, dynamic> m = config['letterFrequencies'];
  m.forEach((k, e) => result[k] = e);

  return result;
}

Future<String> loadConfigJson() async {
  return await rootBundle.loadString('assets/config.json');
}

Future<String> loadDictionary() async {
  return await rootBundle.loadString('assets/words_nl.txt');
}

Future<Dictionary> readDutchWords(String fileName) async {
  var source = File(fileName);
  List<String> contents = await source.readAsLines();
  contents.sort();
  return Dictionary(contents);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Provider(
            data: ValueNotifier(UserAnswer.start()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                WordCountRow(),
                WordWindow(),
                Grid(),
              ],
            )));
  }
}

class WordCountRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(_solution.uniqueWordsSorted());

    List<Widget> infoCol = [];
    for (int i = 2; i <= 9; i++) {
      var wordCount2 = _solution.countForLength(i);
      infoCol.add(WordCountColumn(i, wordCount2, false));
    }
    infoCol.add(WordCountColumn(10, _solution.countForMinLength(10), true));

    return Row(children: infoCol);
  }
}

class WordCountColumn extends StatelessWidget {
  final int size, count;
  final bool last;

  final textStyle = TextStyle(fontSize: 20.0);

  WordCountColumn(this.size, this.count, this.last);

  @override
  Widget build(BuildContext context) {
    UserAnswer data = Provider.of(context).value;
    String found =
        (last ? data.countForMinLength(size) : data.countForLength(size))
            .toString();
    if (last) {
      found += " >";
    }

    return Column(
      children: [
        Text(size.toString(), style: textStyle),
        Text(count.toString(), style: textStyle),
        Text(found, style: textStyle),
      ],
    );
  }
}

class WordWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of(context).value;
    return Text("${data.latestUserWord}",
        style:
            TextStyle(color: data.latestCorrect ? Colors.green : Colors.red));
  }
}

class Grid extends StatefulWidget {
  @override
  GridState createState() {
    return new GridState();
  }
}

class GridState extends State<Grid> {
  final List<int> _selectedIndexes = [];
  final _key = GlobalKey();

  bool _validStart = false;

  _start(PointerEvent event) {
    _validStart = true;
    _detectTapedItem(event);
  }

  _move(PointerEvent event) {
    if (_validStart) {
      _detectTapedItem(event);
    }
  }

  _detectTapedItem(PointerEvent event) {
    final RenderBox box = _key.currentContext.findRenderObject();
    final result = HitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        if (target is _IndexedRenderObject) {
          if (!_selectedIndexes.contains(target.index)) {
            setState(() {
              _selectedIndexes.add(target.index);
            });
          } else if (_selectedIndexes.last != target.index) {
            _clearSelection();
          }
        }
      }
    }
  }

  void _finish(PointerUpEvent event) {
    if (_validStart) {
      var word = StringBuffer();
      for (var index in _selectedIndexes) {
        var xy = _indexToXY(index);
        word.write(_board.characterAt(Coordinate(xy[0], xy[1])));
      }

      var candidate = word.toString();

      UserAnswer old = Provider.of(_key.currentContext).value;
      Provider.of(_key.currentContext).value =
          UserAnswer.extend(old, candidate, _solution.isCorrect(candidate));
    }

    _clearSelection();
  }

  void _clearSelection() {
    setState(() {
      _validStart = false;
      _selectedIndexes.clear();
    });
  }

  _indexToXY(int index) {
    int y = (index / _board.width).floor();
    int x = index - (y * _board.width).floor();
    return [x, y];
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _start,
      onPointerMove: _move,
      onPointerUp: _finish,
      child: Container(
//        width: 300.0,
        child: GridView.builder(
          shrinkWrap: true,
          key: _key,
          itemCount: 9,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.blueAccent)),
              child: Padding(
                padding: new EdgeInsets.all(20.0),
                child: _buildIndexedWidget(index),
              ),
            );
          },
        ),
      ),
    );
  }

  _IndexedWidget _buildIndexedWidget(int index) {
    var xy = _indexToXY(index);

    return _IndexedWidget(
      index: index,
      child: Container(
        color: _selectedIndexes.contains(index) ? Colors.green : Colors.blue,
        child: Center(
            child: Text(
                _board.characterAt(Coordinate(xy[0], xy[1])).toUpperCase(),
                style: const TextStyle(fontSize: 40.0))),
      ),
    );
  }
}

class _IndexedWidget extends SingleChildRenderObjectWidget {
  final int index;

  _IndexedWidget({Widget child, this.index, Key key})
      : super(child: child, key: key);

  @override
  _IndexedRenderObject createRenderObject(BuildContext context) {
    return _IndexedRenderObject()..index = index;
  }

  @override
  void updateRenderObject(
      BuildContext context, _IndexedRenderObject renderObject) {
    renderObject..index = index;
  }
}

class _IndexedRenderObject extends RenderProxyBox {
  int index;
}
