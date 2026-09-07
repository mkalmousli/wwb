import 'dart:convert';

import '../../core/http_client.dart';
import 'search_provider.dart';

/// npm registry search. Keyless; each package exposes a homepage / repository
/// URL — handy for finding a library's site.
class NpmProvider implements SearchProviderImpl {
  NpmProvider(this._http);

  final HttpClient _http;

  @override
  String get key => 'npm';

  @override
  Future<List<Suggestion>> suggest(String query) async {
    final uri = Uri.parse(
      'https://registry.npmjs.org/-/v1/search',
    ).replace(queryParameters: {'text': query, 'size': '5'});
    final res = await _http.getWithRetry(uri, maxAttempts: 2);
    if (res.statusCode != 200) return [];
    final data = json.decode(res.body) as Map<String, dynamic>;
    final objects = (data['objects'] as List?) ?? const [];
    final out = <Suggestion>[];
    final seen = <String>{};
    for (final o in objects) {
      if (o is! Map) continue;
      final pkg = o['package'];
      if (pkg is! Map) continue;
      final links = pkg['links'];
      var url = links is Map
          ? (links['homepage'] ?? links['repository'] ?? links['npm'])
                as String?
          : null;
      if (url == null || url.isEmpty) continue;
      url = url
          .replaceFirst(RegExp(r'^git\+'), '')
          .replaceFirst(RegExp(r'\.git$'), '');
      if (!seen.add(url)) continue;
      out.add(
        Suggestion(
          url: url,
          label:
              '${pkg['name']}'
              '${pkg['description'] != null ? ' — ${pkg['description']}' : ''}',
          source: 'npm',
        ),
      );
      if (out.length >= 3) break;
    }
    return out;
  }
}
