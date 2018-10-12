import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/provider.dart';

class WordWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = Provider.mutableDataOf(context).value;
    return Text("${data.latestUserWord}",
        style: TextStyle(
            fontSize: 40.0,
            color: data.latestCorrect ? Colors.green : Colors.red));
  }
}
