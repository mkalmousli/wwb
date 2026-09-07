import 'dart:convert';

import '../../core/api_log.dart';
import '../../core/http_client.dart';
import 'wayback_models.dart';

/// Client for the Wayback Machine's internal `__wb` calendar endpoints.
/// These are dramatically faster than the CDX API for availability data.
class WbCalendarApi {
  WbCalendarApi(this._http);

  final HttpClient _http;

  static const _base = 'https://web.archive.org/__wb';

  int _asInt(Object? v) {
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }

  /// `/__wb/sparkline` → monthly capture counts per year for the whole history
  /// in a single request. Returns `{ year: [12 monthly counts] }`.
  Future<Map<int, List<int>>> sparkline(String url, {ApiLog? log}) async {
    final uri = Uri.parse('$_base/sparkline').replace(
      queryParameters: {'output': 'json', 'url': url, 'collection': 'web'},
    );
    log?.call('Sparkline · $url');
    final res = await _http.getWithRetry(uri, log: log, maxAttempts: 3);
    if (res.statusCode != 200 || res.body.trim().isEmpty) {
      throw Exception('sparkline HTTP ${res.statusCode}');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final years = (data['years'] as Map?) ?? const {};
    final out = <int, List<int>>{};
    for (final e in years.entries) {
      final y = int.tryParse('${e.key}');
      if (y == null) continue;
      final months = (e.value as List?) ?? const [];
      out[y] = [for (final m in months) _asInt(m)];
    }
    log?.call('Sparkline: ${out.length} years', done: true);
    return out;
  }

  /// `/__wb/calendarcaptures/2?date=YYYY&groupby=day` → every day of the year
  /// with its capture count, in one request. Returns `{ 'YYYYMMDD': count }`.
  Future<Map<String, int>> yearDayCounts(
    String url,
    int year, {
    ApiLog? log,
  }) async {
    final uri = Uri.parse(
      '$_base/calendarcaptures/2',
    ).replace(queryParameters: {'url': url, 'date': '$year', 'groupby': 'day'});
    log?.call('Calendar · $year (whole year, grouped by day)');
    final res = await _http.getWithRetry(uri, log: log, maxAttempts: 3);
    if (res.statusCode != 200 || res.body.trim().isEmpty) {
      throw Exception('calendarcaptures HTTP ${res.statusCode}');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final items = (data['items'] as List?) ?? const [];
    final out = <String, int>{};
    for (final it in items) {
      if (it is! List || it.isEmpty) continue;
      final mmdd = _asInt(it[0]); // e.g. 1017 = Oct 17
      final mm = mmdd ~/ 100;
      final dd = mmdd % 100;
      if (mm < 1 || mm > 12 || dd < 1 || dd > 31) continue;
      final count = it.length >= 3 ? _asInt(it[2]) : 1;
      out['$year${mm.toString().padLeft(2, '0')}${dd.toString().padLeft(2, '0')}'] =
          count;
    }
    log?.call('$year: ${out.length} days with captures', done: true);
    return out;
  }

  /// `/__wb/calendarcaptures/2?date=YYYYMMDD` → every capture that day.
  /// Items are `[HHMMSS, status, collectionIndex]`.
  Future<List<WaybackSnapshot>> daySnapshots(
    String url,
    DateTime day, {
    ApiLog? log,
  }) async {
    final d =
        '${day.year}${day.month.toString().padLeft(2, '0')}'
        '${day.day.toString().padLeft(2, '0')}';
    final uri = Uri.parse(
      '$_base/calendarcaptures/2',
    ).replace(queryParameters: {'url': url, 'date': d});
    log?.call('Calendar · captures for $d');
    final res = await _http.getWithRetry(uri, log: log, maxAttempts: 3);
    if (res.statusCode != 200 || res.body.trim().isEmpty) {
      throw Exception('calendarcaptures HTTP ${res.statusCode}');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final items = (data['items'] as List?) ?? const [];
    final out = <WaybackSnapshot>[];
    for (final it in items) {
      if (it is! List || it.isEmpty) continue;
      final hms = _asInt(it[0]).toString().padLeft(6, '0');
      if (hms.length != 6) continue;
      final statusRaw = it.length >= 2 ? it[1] : null;
      final status = statusRaw is num
          ? statusRaw.toInt()
          : int.tryParse('$statusRaw');
      out.add(
        WaybackSnapshot(
          timestamp: '$d$hms',
          original: url,
          statusCode: status,
          mimeType: null,
        ),
      );
    }
    out.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    log?.call('${out.length} captures on $d', done: true);
    return out;
  }
}
