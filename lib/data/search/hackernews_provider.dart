import 'dart:convert';

import '../../core/http_client.dart';
import 'search_provider.dart';

/// Hacker News search (Algolia). Keyless, CORS-friendly, returns real story
/// URLs — good for finding the canonical site behind a topic.
class HackerNewsProvider implements SearchProviderImpl {
  HackerNewsProvider(this._http);

  final HttpClient _http;

  @override
  String get key => 'hackernews';

  @override
  Future<List<Suggestion>> suggest(String query) async {
    final uri = Uri.parse('https://hn.algolia.com/api/v1/search').replace(
      queryParameters: {'query': query, 'tags': 'story', 'hitsPerPage': '5'},
    );
    final res = await _http.getWithRetry(uri, maxAttempts: 2);
    if (res.statusCode != 200) return [];
    final data = json.decode(res.body) as Map<String, dynamic>;
    final hits = (data['hits'] as List?) ?? const [];
    final out = <Suggestion>[];
    final seen = <String>{};
    for (final h in hits) {
      if (h is! Map) continue;
      final url = h['url'] as String?;
      if (url == null || url.isEmpty) continue;
      if (!seen.add(url)) continue;
      out.add(
        Suggestion(
          url: url,
          label: (h['title'] as String?)?.trim().isNotEmpty == true
              ? h['title'] as String
              : url,
          source: 'Hacker News',
        ),
      );
      if (out.length >= 3) break;
    }
    return out;
  }
}
