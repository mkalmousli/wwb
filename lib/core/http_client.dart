import 'dart:async';
import 'package:http/http.dart' as http;

import 'api_log.dart';

/// Simple HTTP client wrapper with retry + exponential backoff.
class HttpClient {
  HttpClient({http.Client? inner}) : _inner = inner ?? http.Client();

  final http.Client _inner;

  Future<http.Response> getWithRetry(
    Uri url, {
    int maxAttempts = 4,
    Duration timeout = const Duration(seconds: 30),
    Map<String, String>? headers,
    ApiLog? log,
  }) async {
    var attempt = 0;
    while (true) {
      attempt++;
      final label = '${url.host}${url.path}';
      try {
        log?.call('GET $label  (try $attempt/$maxAttempts)');
        final res = await _inner
            .get(url, headers: {'User-Agent': 'WayWayBack/1.0', ...?headers})
            .timeout(timeout);
        if (res.statusCode == 429 || res.statusCode >= 500) {
          throw http.ClientException('HTTP ${res.statusCode}', url);
        }
        log?.call('  ← ${res.statusCode} · ${res.bodyBytes.length} bytes');
        return res;
      } catch (e) {
        if (attempt >= maxAttempts) {
          log?.call('  request failed after $attempt tries: $e', error: true);
          rethrow;
        }
        final wait = Duration(milliseconds: 400 * (1 << (attempt - 1)));
        log?.call(
          '  error: $e — retrying in ${wait.inMilliseconds}ms',
          error: true,
        );
        await Future<void>.delayed(wait);
      }
    }
  }

  void close() => _inner.close();
}
