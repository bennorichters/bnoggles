// Copyright (c) 2018, The Bnoggles Team.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

/// Returns a String representing the time in the format MM:SS
String formatTime(int seconds) {
  int minutes = (seconds / 60).floor();
  String restSeconds = (seconds - 60 * minutes).toString().padLeft(2, "0");
  return "$minutes:$restSeconds";
}
