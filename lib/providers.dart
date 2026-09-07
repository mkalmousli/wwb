import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/http_client.dart';
import 'data/local/database.dart';
import 'data/local/repository.dart';
import 'data/search/link_guesser.dart';
import 'data/search/npm_provider.dart';
import 'data/search/search_provider.dart';
import 'data/search/wikipedia_provider.dart';
import 'data/wayback/wb_calendar.dart';

final httpClientProvider = Provider<HttpClient>((ref) {
  final c = HttpClient();
  ref.onDispose(c.close);
  return c;
});

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final repositoryProvider = Provider<Repository>(
  (ref) => Repository(ref.watch(databaseProvider)),
);

final wbCalendarProvider = Provider<WbCalendarApi>(
  (ref) => WbCalendarApi(ref.watch(httpClientProvider)),
);

final linkGuesserProvider = Provider<LinkGuesser>((ref) => LinkGuesser());

final historyProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(repositoryProvider).watchHistory(),
);

final tabOrderProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(repositoryProvider).watchTabOrder(),
);

final recentSearchesProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(repositoryProvider).watchRecentSearches(),
);

final searchProviderImplsProvider = Provider<Map<String, SearchProviderImpl>>((
  ref,
) {
  final http = ref.watch(httpClientProvider);
  final impls = <SearchProviderImpl>[
    WikipediaProvider(http),
    NpmProvider(http),
  ];
  return {for (final i in impls) i.key: i};
});

final starredWebsitesProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(repositoryProvider).watchStarredWebsites(),
);

final starredSnapshotsProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(repositoryProvider).watchStarredSnapshots(),
);

final providersListProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(repositoryProvider).watchProviders(),
);

/// Debounced web-search-engine suggestions (link guesser is handled separately,
/// synchronously, with no delay).
final engineSuggestionsProvider = FutureProvider.autoDispose
    .family<List<Suggestion>, String>((ref, query) async {
      final q = query.trim();
      if (q.isEmpty) return [];
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final repo = ref.watch(repositoryProvider);
      final impls = ref.watch(searchProviderImplsProvider);
      final enabled = await repo.enabledProviders();

      final results = await Future.wait(
        enabled.where((p) => impls.containsKey(p.key)).map((p) async {
          try {
            return await impls[p.key]!.suggest(q);
          } catch (_) {
            return <Suggestion>[];
          }
        }),
      );

      // Round-robin across providers so every enabled engine gets a look in.
      final seen = <String>{};
      final merged = <Suggestion>[];
      final queues = [for (final l in results) List<Suggestion>.from(l)];
      var added = true;
      while (added && merged.length < 8) {
        added = false;
        for (final q in queues) {
          if (q.isEmpty) continue;
          final s = q.removeAt(0);
          added = true;
          if (seen.add(normalizeUrl(s.url))) merged.add(s);
          if (merged.length >= 8) break;
        }
      }
      return merged;
    });
