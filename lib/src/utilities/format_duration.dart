String formatDuration(Duration duration) {
  // This is taken directly from the Duration class and modified to remove microseconds
  var microseconds = duration.inMicroseconds;
  var sign = (microseconds < 0) ? "-" : "";

  var hours = microseconds ~/ Duration.microsecondsPerHour;
  microseconds = microseconds.remainder(Duration.microsecondsPerHour);

  if (microseconds < 0) microseconds = -microseconds;

  var minutes = microseconds ~/ Duration.microsecondsPerMinute;
  microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

  var minutesPadding = minutes < 10 ? "0" : "";

  var seconds = microseconds ~/ Duration.microsecondsPerSecond;
  microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

  var secondsPadding = seconds < 10 ? "0" : "";

  // var paddedMicroseconds = microseconds.toString().padLeft(6, "0");
  return "$sign${hours.abs()}:"
      "$minutesPadding$minutes:"
      "$secondsPadding$seconds";
}
