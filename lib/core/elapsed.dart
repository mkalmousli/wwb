String fmtElapsed(Duration d) {
  final ms = d.inMilliseconds;
  if (ms < 1000) return '${ms}ms';
  final s = ms / 1000;
  if (s < 60) return '${s.toStringAsFixed(1)}s';
  final m = d.inMinutes;
  final rem = d.inSeconds % 60;
  return '${m}m ${rem}s';
}
