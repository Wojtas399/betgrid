extension DurationFormatting on Duration {
  String toUIDuration() {
    final days = inDays;
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    String durationStr = '${minutes}min';
    if (hours > 0) durationStr = '${hours}h $durationStr';
    if (days > 0) durationStr = '${days}d $durationStr';
    return hours == 0 && days == 0 ? '${seconds}s' : durationStr;
  }
}
