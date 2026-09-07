import 'dart:convert';

import '../../core/http_client.dart';
import 'search_provider.dart';

/// Wikidata (FOSS, CC0). Searches entities, then reads their official-website
/// claim (P856) — a direct, reliable way to find a topic's real site.
class WikidataProvider implements SearchProviderImpl {
  WikidataProvider(this._http);

  final HttpClient _http;

  static const _api = 'https://www.wikidata.org/w/api.php';

  @override
  String get key => 'wikidata';

  @override
  Future<List<Suggestion>> suggest(String query) async {
    final searchUri = Uri.parse(_api).replace(
      queryParameters: {
        'action': 'wbsearchentities',
        'search': query,
        'language': 'en',
        'format': 'json',
        'limit': '5',
        'type': 'item',
        'origin': '*',
      },
    );
    final sr = await _http.getWithRetry(searchUri, maxAttempts: 2);
    if (sr.statusCode != 200) return [];
    final hits = (json.decode(sr.body)['search'] as List?) ?? const [];
    if (hits.isEmpty) return [];

    final ids = <String>[];
    final labels = <String, String>{};
    for (final h in hits) {
      if (h is! Map) continue;
      final id = h['id'] as String?;
      if (id == null) continue;
      ids.add(id);
      labels[id] = [
        if (h['label'] != null) '${h['label']}',
        if (h['description'] != null) '(${h['description']})',
      ].join(' ');
    }
    if (ids.isEmpty) return [];

    final entUri = Uri.parse(_api).replace(
      queryParameters: {
        'action': 'wbgetentities',
        'ids': ids.take(5).join('|'),
        'props': 'claims',
        'format': 'json',
        'origin': '*',
      },
    );
    final er = await _http.getWithRetry(entUri, maxAttempts: 2);
    if (er.statusCode != 200) return [];
    final entities = (json.decode(er.body)['entities'] as Map?) ?? const {};

    final out = <Suggestion>[];
    final seen = <String>{};
    for (final id in ids) {
      final claims = (entities[id]?['claims'] as Map?) ?? const {};
      for (final c in (claims['P856'] as List? ?? const [])) {
        String? url;
        if (c is Map) {
          final v = c['mainsnak']?['datavalue']?['value'];
          if (v is String) url = v;
        }
        if (url == null || url.isEmpty || !seen.add(url)) continue;
        out.add(
          Suggestion(url: url, label: labels[id] ?? url, source: 'Wikidata'),
        );
        break; // one canonical site per entity
      }
      if (out.length >= 3) break;
    }
    return out;
  }
}
