class Suggestion {
  Suggestion({required this.url, required this.label, required this.source});

  final String url;
  final String label;
  final String source;
}

abstract class SearchProviderImpl {
  String get key;
  Future<List<Suggestion>> suggest(String query);
}
