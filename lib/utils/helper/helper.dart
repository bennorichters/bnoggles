String formatTime(int seconds) {
  int minutes = (seconds / 60).floor();
  String restSeconds = (seconds - 60 * minutes).toString().padLeft(2, "0");
  return "$minutes:$restSeconds";
}
