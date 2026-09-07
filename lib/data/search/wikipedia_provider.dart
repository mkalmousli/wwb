import 'dart:convert';

import '../../core/http_client.dart';
import 'search_provider.dart';

class WikipediaProvider implements SearchProviderImpl {
  WikipediaProvider(this._http);

  final HttpClient _http;

  @override
  String get key => 'wikipedia';

  @override
  Future<List<Suggestion>> suggest(String query) async {
    final uri = Uri.parse('https://en.wikipedia.org/w/api.php').replace(
      queryParameters: {
        'action': 'opensearch',
        'search': query,
        'limit': '3',
        'namespace': '0',
        'format': 'json',
      },
    );
    final res = await _http.getWithRetry(uri, maxAttempts: 2);
    if (res.statusCode != 200) return [];
    final data = json.decode(res.body) as List;
    if (data.length < 4) return [];
    final titles = (data[1] as List).cast<String>();
    final links = (data[3] as List).cast<String>();
    final out = <Suggestion>[];
    for (var i = 0; i < links.length; i++) {
      out.add(
        Suggestion(
          url: links[i],
          label: i < titles.length ? titles[i] : links[i],
          source: 'Wikipedia',
        ),
      );
    }
    return out;
  }
}
