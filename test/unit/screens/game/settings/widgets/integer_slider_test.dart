import 'package:bnoggles/screens/settings/widgets/integer_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('find icon and label', (WidgetTester tester) async {
    ValueNotifier<int> v = ValueNotifier(0);
    var list = IntSlider.create(
      v,
      Icons.ac_unit,
      (i) => 'txt',
      min: 0,
      max: 9,
    );
    await tester.pumpWidget(testable(children: list));

    var icon = find.byIcon(Icons.ac_unit);
    expect(icon, findsOneWidget);

    var label = find.text('txt');
    expect(label, findsOneWidget);
  });

  testWidgets('tap slider', (WidgetTester tester) async {
    ValueNotifier<int> v = ValueNotifier(0);
    var list = IntSlider.create(
      v,
      Icons.ac_unit,
      (i) => i.toString(),
      min: 0,
      max: 9,
    );
    await tester.pumpWidget(testable(children: list));

    var slider = find.byType(Slider);
    expect(slider, findsOneWidget);

    var topLeft = tester.getTopLeft(slider);
    var bottomRight = tester.getBottomRight(slider);
    var step = (bottomRight.dx - topLeft.dx) / 10;
    var middleY = (bottomRight.dy - topLeft.dy) / 2;

    for (int i = 0; i < 10; i++) {
      var target = topLeft + Offset(step * (i + .5), middleY);
      await tester.tapAt(target);
      await tester.pump();
      
      expect(v.value, i);

      var label = find.text(i.toString());
      expect(label, findsOneWidget);
    }
  });
}

Widget testable({List<Widget> children}) {
  return MaterialApp(
    home: Material(
      child: Row(
        children: children,
      ),
    ),
  );
}
