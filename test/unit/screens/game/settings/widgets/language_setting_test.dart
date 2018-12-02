// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:bnoggles/screens/settings/widgets/language_setting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:transparent_image/transparent_image.dart';

import 'test_helper.dart';

void main() {
  testWidgets('find icon and label', (WidgetTester tester) async {
    ValueNotifier<int> v = ValueNotifier(0);
    var list = LanguageSetting.create(v, Icons.ac_unit);
    await tester.pumpWidget(testable(children: list));

    var icon = find.byIcon(Icons.ac_unit);
    expect(icon, findsOneWidget);

    var images = find.byType(Image);
    expect(images, findsNWidgets(3));
  });

  Opacity _firstChild(Finder finder) {
    var widget = finder.evaluate().single.widget as GestureDetector;
    return widget.child as Opacity;
  }

  testWidgets('en', (WidgetTester tester) async {
    ValueNotifier<int> v = ValueNotifier(0);
    var list = LanguageSetting.create(v, Icons.ac_unit);
    await tester.pumpWidget(testableImage(children: list));

    var nl = find.byKey(Key('LSGD_nl'));
    var en = find.byKey(Key('LSGD_en'));
    var hu = find.byKey(Key('LSGD_hu'));

    expect(v.value, 0);
    expect(_firstChild(nl).opacity, 1.0);
    expect(_firstChild(en).opacity < 1, true);
    expect(_firstChild(hu).opacity < 1, true);

    await tester.tap(en);
    await tester.pump();

    expect(v.value, 1);
    expect(_firstChild(nl).opacity < 1, true);
    expect(_firstChild(en).opacity, 1);
    expect(_firstChild(hu).opacity < 1, true);
  });
}

Widget testableImage({List<Widget> children}) => MaterialApp(
      home: DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: Material(
          child: Row(
            children: children,
          ),
        ),
      ),
    );

class TestAssetBundle extends CachingAssetBundle {
  TestAssetBundle();
  final String manifest = '{}';

  @override
  Future<ByteData> load(String key) =>
      SynchronousFuture<ByteData>(ByteData.view(kTransparentImage.buffer));

  @override
  Future<String> loadString(String key, {bool cache = true}) =>
      SynchronousFuture<String>(
          (key == 'AssetManifest.json') ? manifest : null);
}
