import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'src/board.dart';
import 'src/coordinate.dart';
import 'src/dictionary.dart';
import 'src/solution.dart';

Board _board;
Set<Solution> _solutions;

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

  _solutions = solve(_board, dict);

  compareWords(String a, String b) {
    var compareLength = a.length.compareTo(b.length);
    return (compareLength == 0) ? a.compareTo(b) : compareLength;
  }

//  solutions.map((s) => s.word).toSet().toList()
//    ..sort((a, b) => compareWords(a, b))
//    ..forEach(print);

  var groupedByLength =
      groupBy(_solutions.map((s) => s.word).toSet(), (s) => s.length);

  groupedByLength.keys.toList()
    ..sort()
    ..forEach((e) => print('$e - ${groupedByLength[e]}'));
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
      body: Grid(),
    );
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
      print(word);
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(children: [Text('a'), Text('b')]),
        Row(children: [Text('a'), Text('b')]),
        _boardWidget(),
      ],
    );
  }

  _boardWidget() {
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
