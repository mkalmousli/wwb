import 'search_provider.dart';

class LinkGuesser implements SearchProviderImpl {
  @override
  String get key => 'link_guesser';

  @override
  Future<List<Suggestion>> suggest(String query) async => guess(query);

  /// Synchronous — guesses have no network cost, so they show instantly.
  List<Suggestion> guess(String query) {
    final q = query.trim();
    if (q.isEmpty) return [];

    if (q.contains('://') || q.startsWith('www.')) {
      final normalized = q.contains('://') ? q : 'https://$q';
      return [Suggestion(url: normalized, label: normalized, source: 'Guess')];
    }

    final host = q.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    final out = <Suggestion>[];
    if (host.contains('.')) {
      out.add(
        Suggestion(
          url: 'https://$host',
          label: 'https://$host',
          source: 'Guess',
        ),
      );
      out.add(
        Suggestion(
          url: 'https://www.$host',
          label: 'https://www.$host',
          source: 'Guess',
        ),
      );
    } else {
      for (final tld in const ['com', 'org', 'net', 'io']) {
        out.add(
          Suggestion(
            url: 'https://$host.$tld',
            label: 'https://$host.$tld',
            source: 'Guess',
          ),
        );
      }
    }
    return out;
  }
}
