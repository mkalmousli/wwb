import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/favicon.dart';
import '../../core/platform.dart';
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
  bool _showShareHint = false;

  @override
  void initState() {
    super.initState();
    if (AppPlatform.isMobile) {
      ref.read(repositoryProvider).shareHintDismissed().then((dismissed) {
        if (mounted && !dismissed) setState(() => _showShareHint = true);
      });
    }
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
    // Replace Search with the calendar — Back should return to Home, not here.
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => LinkScreen(url: url)));
  }

  void _dismissShareHint() {
    ref.read(repositoryProvider).dismissShareHint();
    setState(() => _showShareHint = false);
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
          if (_showShareHint) _shareHint(),
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

  Widget _shareHint() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.ios_share, size: 20, color: cs.onSecondaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tip: share a link from any app into WayWayBack to open its '
              'archive straight away.',
              style: TextStyle(color: cs.onSecondaryContainer, fontSize: 13),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            tooltip: 'Dismiss',
            color: cs.onSecondaryContainer,
            onPressed: _dismissShareHint,
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
