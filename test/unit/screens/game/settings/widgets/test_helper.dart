// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

Widget testableRow({List<Widget> children}) => MaterialApp(
      home: Material(
        child: Row(
          children: children,
        ),
      ),
    );

Widget testableWidget({Widget child}) => MaterialApp(
      home: Material(
        child: child,
      ),
    );
