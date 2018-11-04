// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

Future<List<String>> linesFromFile(String name) async {
  var input = File(name);
  var contents = await input.readAsLines();
  return contents;
}