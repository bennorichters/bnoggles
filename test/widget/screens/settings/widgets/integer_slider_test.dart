// Copyright (c) 2019, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/settings/widgets/integer_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helper.dart';

void main() {
  testWidgets('find icon and label', (WidgetTester tester) async {
    ValueNotifier<int> v = ValueNotifier(0);
    var list = intSlider(
      sliderNotifier: v,
      icon: const Icon(
        Icons.ac_unit,
        size: 40,
      ),
      label: (i) => 'txt',
      min: 0,
      max: 9,
    );
    await tester.pumpWidget(testableRow(children: list));

    var icon = find.byIcon(Icons.ac_unit);
    expect(icon, findsOneWidget);

    var label = find.text('txt');
    expect(label, findsOneWidget);
  });

  testWidgets('tap slider', (WidgetTester tester) async {
    ValueNotifier<int> v = ValueNotifier(8);
    var list = intSlider(
      sliderNotifier: v,
      icon: const Icon(
        Icons.ac_unit,
        size: 40,
      ),
      label: (i) => i.toString(),
      min: 8,
      max: 16,
      stepSize: 2,
    );
    await tester.pumpWidget(testableRow(children: list));

    var slider = find.byType(Slider);
    expect(slider, findsOneWidget);

    Slider sliderWidget = slider.evaluate().single.widget as Slider;
    expect(sliderWidget.min, 8);
    expect(sliderWidget.max, 16);
    expect(sliderWidget.divisions, 4);

    await tester.tapAt(tester.getCenter(slider));
    await tester.pump();

    expect(v.value, 12);
    var label = find.text('12');
    expect(label, findsOneWidget);
  });

  testWidgets('switch disables slider', (WidgetTester tester) async {
    ValueNotifier<int> sliderValue = ValueNotifier(8);
    ValueNotifier<bool> switchValue = ValueNotifier(true);

    var list = intSlider(
      sliderNotifier: sliderValue,
      icon: const Icon(
        Icons.ac_unit,
        size: 40,
      ),
      switchNotifier: switchValue,
      label: (i) => i.toString(),
      min: 8,
      max: 16,
      stepSize: 2,
    );

    Widget w = Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.all(5.0),
      child: Table(
          columnWidths: {
            0: FixedColumnWidth(50.0),
            1: FixedColumnWidth(60.0),
            2: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: list),
          ]),
    );

    await tester.pumpWidget(testableWidget(child: w));

    expect(find.text('8'), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.text('8'), findsNothing);

    await tester.tapAt(tester.getCenter(find.byType(Slider)));
    await tester.pumpAndSettle();

    expect(find.text('12'), findsNothing);
  });
}
