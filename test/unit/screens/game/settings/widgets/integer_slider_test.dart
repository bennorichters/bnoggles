// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/settings/widgets/integer_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('find icon and label', (WidgetTester tester) async {
    ValueNotifier<int> v = ValueNotifier(0);
    var list = intSlider(
      notifier: v,
      icon: Icons.ac_unit,
      label: (i) => 'txt',
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
    ValueNotifier<int> v = ValueNotifier(8);
    var list = intSlider(
      notifier: v,
      icon: Icons.ac_unit,
      label: (i) => i.toString(),
      min: 8,
      max: 16,
      stepSize: 2,
    );
    await tester.pumpWidget(testable(children: list));

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
