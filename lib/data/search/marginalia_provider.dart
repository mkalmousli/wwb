import 'dart:convert';

import '../../core/http_client.dart';
import 'search_provider.dart';

/// Marginalia (AGPL) — an independent, non-commercial search engine with its
/// own crawled index. Keyless public API.
class MarginaliaProvider implements SearchProviderImpl {
  MarginaliaProvider(this._http);

  final HttpClient _http;

  @override
  String get key => 'marginalia';

  @override
  Future<List<Suggestion>> suggest(String query) async {
    final uri = Uri.parse(
      'https://api.marginalia.nu/public/search/${Uri.encodeComponent(query)}',
    ).replace(queryParameters: {'count': '5', 'index': '0'});
    final res = await _http.getWithRetry(
      uri,
      maxAttempts: 2,
      timeout: const Duration(seconds: 12),
    );
    if (res.statusCode != 200) return [];
    final results = (json.decode(res.body)['results'] as List?) ?? const [];
    final out = <Suggestion>[];
    final seen = <String>{};
    for (final r in results) {
      if (r is! Map) continue;
      final url = r['url'] as String?;
      if (url == null || url.isEmpty || !seen.add(url)) continue;
      out.add(
        Suggestion(
          url: url,
          label: (r['title'] as String?)?.trim().isNotEmpty == true
              ? r['title'] as String
              : url,
          source: 'Marginalia',
        ),
      );
      if (out.length >= 3) break;
    }
    return out;
  }
}
