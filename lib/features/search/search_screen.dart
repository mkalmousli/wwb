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

  void _open(String url) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => LinkScreen(url: url)));
  }

  @override
  Widget build(BuildContext context) {
    final guesses = ref.watch(linkGuesserProvider).guess(_query);
    final enginesAsync = _query.trim().isEmpty
        ? const AsyncValue<List<Suggestion>>.data([])
        : ref.watch(engineSuggestionsProvider(_query));

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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a URL or search term',
                prefixIcon: Icon(Icons.search),
              ),
              textInputAction: TextInputAction.go,
              onChanged: (v) => setState(() => _query = v),
              onSubmitted: (_) {
                final c = _combined();
                if (c.isNotEmpty) _open(c.first.url);
              },
            ),
          ),
          if (enginesAsync.isLoading)
            const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      _query.trim().isEmpty
                          ? 'Start typing…'
                          : 'No suggestions',
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
}
