import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/favicon.dart';
import '../../data/local/repository.dart';
import '../../data/search/search_provider.dart';
import '../../providers.dart';
import '../link/link_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  bool _restored = false;

  @override
  void initState() {
    super.initState();
    // Restore the last query so its suggestions are ready straight away.
    ref.read(repositoryProvider).recentSearches().then((list) {
      if (!mounted || _restored) return;
      if (list.isNotEmpty && _controller.text.isEmpty) {
        setState(() {
          _controller.text = list.first.query;
          _controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controller.text.length,
          );
          _query = list.first.query;
          _restored = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Suggestion> _combined() {
    final guesses = ref.read(linkGuesserProvider).guess(_query);
    final engines = _query.trim().isEmpty
        ? const <Suggestion>[]
        : (ref.read(engineSuggestionsProvider(_query)).valueOrNull ??
              const <Suggestion>[]);
    final seen = <String>{};
    final out = <Suggestion>[];
    for (final s in [...guesses, ...engines]) {
      if (seen.add(normalizeUrl(s.url))) out.add(s);
    }
    return out;
  }

  void _open(String url, {String? query}) {
    ref.read(repositoryProvider).addRecentSearch(query ?? _query, url);
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => LinkScreen(url: url)));
  }

  @override
  Widget build(BuildContext context) {
    final empty = _query.trim().isEmpty;
    final guesses = ref.watch(linkGuesserProvider).guess(_query);
    final enginesAsync = empty
        ? const AsyncValue<List<Suggestion>>.data([])
        : ref.watch(engineSuggestionsProvider(_query));
    final recent = ref.watch(recentSearchesProvider).valueOrNull ?? const [];

    final seen = <String>{};
    final items = <Suggestion>[];
    for (final s in [...guesses, ...(enginesAsync.valueOrNull ?? const [])]) {
      if (seen.add(normalizeUrl(s.url))) items.add(s);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Enter a URL or search term',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      ),
              ),
              textInputAction: TextInputAction.go,
              onChanged: (v) => setState(() => _query = v),
              onSubmitted: (_) {
                final c = _combined();
                if (c.isNotEmpty) _open(c.first.url);
              },
            ),
          ),
          if (enginesAsync.isLoading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: empty
                ? _recentList(recent)
                : items.isEmpty
                ? Center(
                    child: Text(
                      enginesAsync.isLoading ? 'Searching…' : 'No suggestions',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final s = items[i];
                      final isGuess = s.source == 'Guess';
                      return ListTile(
                        leading: Favicon(s.url, size: 22),
                        title: Text(
                          s.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: isGuess
                            ? null
                            : Text(
                                s.url,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                        trailing: isGuess
                            ? null
                            : Chip(
                                label: Text(s.source),
                                visualDensity: VisualDensity.compact,
                              ),
                        onTap: () => _open(s.url),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _recentList(List<RecentSearch> recent) {
    if (recent.isEmpty) {
      return Center(
        child: Text(
          'Start typing to search',
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
      );
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
          child: Row(
            children: [
              Text(
                'Recent',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    ref.read(repositoryProvider).clearRecentSearches(),
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
        for (final r in recent)
          ListTile(
            leading: Favicon(r.url, size: 22),
            title: Text(
              r.query,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              r.url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.north_west, size: 18),
              tooltip: 'Use',
              onPressed: () {
                _controller.text = r.query;
                _controller.selection = TextSelection.collapsed(
                  offset: r.query.length,
                );
                setState(() => _query = r.query);
              },
            ),
            onTap: () => _open(r.url, query: r.query),
          ),
      ],
    );
  }
}
