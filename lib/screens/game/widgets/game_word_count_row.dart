import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:bnoggles/screens/game/widgets/provider.dart';

import 'package:bnoggles/utils/solution.dart';

const int _maxLength = 8;

class WordCountRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Solution solution = Provider.immutableDataOf(context)["solution"];

    print(solution.uniqueWordsSorted());

    return GridView.builder(
      shrinkWrap: true,
      itemCount: ((_maxLength - 1) * 3),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (_maxLength - 1),
        childAspectRatio: 1.0,
        crossAxisSpacing: 3.0,
        mainAxisSpacing: 3.0,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration:
              new BoxDecoration(border: new Border.all(color: Colors.orange)),
          child: Padding(
            padding: new EdgeInsets.all(2.0),
            child: fromIndex(index, solution),
          ),
        );
      },
    );
  }

  Widget fromIndex(int index, Solution solution) {
    int rowSize = (_maxLength - 1);
    int lastIndexRow1 = rowSize - 1;
    int lastIndexRow2 = lastIndexRow1 + rowSize;

    int length = (index % (_maxLength - 1)) + 2;

    if (index <= lastIndexRow1) {
      return NumberInfo(length.toString(), Colors.cyan);
    } else if (index <= lastIndexRow2) {
      return NumberInfo(
          solution.countForLength(length).toString(), Colors.orange);
    }

    return UserAnswerNumberInfo(length);
  }
}

class NumberInfo extends StatelessWidget {
  final String number;
  final Color color;
  NumberInfo(this.number, this.color);

  @override
  build(BuildContext context) {
    return Container(
      color: color,
      child: Center(child: Text(number)),
    );
  }
}

class UserAnswerNumberInfo extends StatelessWidget {
  final int length;
  UserAnswerNumberInfo(this.length);

  @override
  build(BuildContext context) {
    UserAnswer userAnswer = Provider.mutableDataOf(context).value;

    return Container(
      color: Colors.amber,
      child: Center(child: Text(userAnswer.countForLength(length).toString())),
    );
  }
}
