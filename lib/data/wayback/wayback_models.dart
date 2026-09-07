class WaybackSnapshot {
  WaybackSnapshot({
    required this.timestamp,
    required this.original,
    this.statusCode,
    this.mimeType,
  });

  final String timestamp; // 14-digit
  final String original;
  final int? statusCode;
  final String? mimeType;

  DateTime get dateTime => DateTime(
    int.parse(timestamp.substring(0, 4)),
    int.parse(timestamp.substring(4, 6)),
    int.parse(timestamp.substring(6, 8)),
    int.parse(timestamp.substring(8, 10)),
    int.parse(timestamp.substring(10, 12)),
    int.parse(timestamp.substring(12, 14)),
  );

  String get waybackUrl => 'https://web.archive.org/web/$timestamp/$original';
}
