import 'dart:convert';

import '../../core/http_client.dart';
import 'search_provider.dart';

/// DuckDuckGo Instant Answer API. It only reliably yields real external URLs
/// via `AbstractURL` and `Results` — `RelatedTopics` are DuckDuckGo's own
/// disambiguation pages (`duckduckgo.com/…`), so we drop anything on that host.
class DuckDuckGoProvider implements SearchProviderImpl {
  DuckDuckGoProvider(this._http);

  final HttpClient _http;

  @override
  String get key => 'duckduckgo';

  bool _isJunk(String u) {
    final host = Uri.tryParse(u)?.host ?? '';
    return host.isEmpty || host.endsWith('duckduckgo.com');
  }

  @override
  Future<List<Suggestion>> suggest(String query) async {
    final uri = Uri.parse('https://api.duckduckgo.com/').replace(
      queryParameters: {
        'q': query,
        'format': 'json',
        'no_html': '1',
        'no_redirect': '1',
        't': 'waywayback',
      },
    );
    final res = await _http.getWithRetry(uri, maxAttempts: 2);
    if (res.statusCode != 200) return [];
    final data = json.decode(res.body) as Map<String, dynamic>;
    final out = <Suggestion>[];
    final seen = <String>{};

    String clean(String s) => s
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    void add(String? u, String? label) {
      if (u == null || u.isEmpty || _isJunk(u)) return;
      if (!seen.add(u)) return;
      final l = (label != null && label.isNotEmpty) ? clean(label) : u;
      out.add(Suggestion(url: u, label: l, source: 'DuckDuckGo'));
    }

    add(data['AbstractURL'] as String?, data['Heading'] as String?);
    add(data['Redirect'] as String?, query);
    for (final r in (data['Results'] as List? ?? const [])) {
      if (r is Map) add(r['FirstURL'] as String?, r['Text'] as String?);
    }
    return out.take(3).toList();
  }
}
