import 'package:bnoggles/screens/settings/widgets/toggle_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('find icon', (WidgetTester tester) async {
    ValueNotifier<bool> v = ValueNotifier(true);
    var list = ToggleSetting.create(v, Icons.ac_unit);
    await tester.pumpWidget(wrap(child: list[0]));

    var icon = find.byIcon(Icons.ac_unit);

    expect(icon, findsOneWidget);
  });
}

Widget wrap({ Widget child }) {
  return MaterialApp(
    home: Center(
      child: Material(child: child),
    ),
  );
}