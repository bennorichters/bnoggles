import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/provider.dart';

import 'package:bnoggles/utils/solution.dart';

class WordCountRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Solution solution = Provider.immutableDataOf(context)["solution"];

    print(solution.uniqueWordsSorted());

    List<Widget> infoCol = [];
    for (int i = 2; i <= 9; i++) {
      var wordCount2 = solution.countForLength(i);
      infoCol.add(WordCountColumn(i, wordCount2, false));
    }
    infoCol.add(WordCountColumn(10, solution.countForMinLength(10), true));

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
    UserAnswer data = Provider.mutableDataOf(context).value;
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