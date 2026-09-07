import 'dart:convert';

import 'package:drift/drift.dart';

import 'database.dart';

enum HistoryKind { website, snapshot }

class HistoryEntry {
  HistoryEntry({
    required this.kind,
    required this.url,
    required this.label,
    this.sublabel,
    required this.visitedAt,
  });

  final HistoryKind kind;
  final String url; // what tapping it opens
  final String label;
  final String? sublabel;
  final DateTime visitedAt;

  Map<String, dynamic> toJson() => {
    'kind': kind.name,
    'url': url,
    'label': label,
    'sublabel': sublabel,
    'at': visitedAt.toIso8601String(),
  };

  static HistoryEntry? fromJson(Object? j) {
    if (j is! Map) return null;
    final at = DateTime.tryParse('${j['at']}');
    if (at == null || j['url'] == null) return null;
    return HistoryEntry(
      kind: HistoryKind.values.firstWhere(
        (k) => k.name == j['kind'],
        orElse: () => HistoryKind.website,
      ),
      url: '${j['url']}',
      label: '${j['label'] ?? j['url']}',
      sublabel: j['sublabel'] as String?,
      visitedAt: at,
    );
  }
}

const kDefaultTabOrder = ['websites', 'snapshots', 'history'];

class RecentSearch {
  RecentSearch({required this.query, required this.url, required this.at});

  final String query;
  final String url;
  final DateTime at;

  Map<String, dynamic> toJson() => {
    'q': query,
    'url': url,
    'at': at.toIso8601String(),
  };

  static RecentSearch? fromJson(Object? j) {
    if (j is! Map || j['q'] == null || j['url'] == null) return null;
    return RecentSearch(
      query: '${j['q']}',
      url: '${j['url']}',
      at: DateTime.tryParse('${j['at']}') ?? DateTime.now(),
    );
  }
}

String normalizeUrl(String raw) {
  var u = raw.trim();
  if (!u.contains('://')) u = 'https://$u';
  final uri = Uri.tryParse(u);
  if (uri == null) return u;
  var host = uri.host.toLowerCase();
  var path = uri.path;
  if (path.endsWith('/')) path = path.substring(0, path.length - 1);
  final rebuilt = '${uri.scheme}://$host$path';
  return rebuilt;
}

class Repository {
  Repository(this.db);

  final AppDatabase db;

  // ---- websites ----
  Future<Website> upsertWebsite(String url, {String? title}) async {
    final norm = normalizeUrl(url);
    final existing = await (db.select(
      db.websites,
    )..where((w) => w.url.equals(norm))).getSingleOrNull();
    if (existing != null) {
      if (title != null && existing.title == null) {
        await (db.update(db.websites)..where((w) => w.id.equals(existing.id)))
            .write(WebsitesCompanion(title: Value(title)));
      }
      return existing;
    }
    final id = await db
        .into(db.websites)
        .insert(WebsitesCompanion.insert(url: norm, title: Value(title)));
    return (db.select(db.websites)..where((w) => w.id.equals(id))).getSingle();
  }

  Stream<Website?> watchWebsite(int id) => (db.select(
    db.websites,
  )..where((w) => w.id.equals(id))).watchSingleOrNull();

  Stream<List<Website>> watchStarredWebsites() =>
      (db.select(db.websites)
            ..where((w) => w.starred.equals(true))
            ..orderBy([(w) => OrderingTerm.desc(w.starredAt)]))
          .watch();

  Future<void> setWebsiteStar(int id, bool starred) =>
      (db.update(db.websites)..where((w) => w.id.equals(id))).write(
        WebsitesCompanion(
          starred: Value(starred),
          starredAt: Value(starred ? DateTime.now() : null),
        ),
      );

  // ---- snapshots ----
  Future<void> cacheSnapshot({
    required int websiteId,
    required String timestamp,
    required String originalUrl,
    int? statusCode,
    String? mimeType,
  }) async {
    await db
        .into(db.snapshots)
        .insert(
          SnapshotsCompanion.insert(
            websiteId: websiteId,
            timestamp: timestamp,
            originalUrl: originalUrl,
            statusCode: Value(statusCode),
            mimeType: Value(mimeType),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<Snapshot?> findSnapshot(int websiteId, String timestamp) =>
      (db.select(db.snapshots)..where(
            (s) =>
                s.websiteId.equals(websiteId) & s.timestamp.equals(timestamp),
          ))
          .getSingleOrNull();

  Stream<List<Snapshot>> watchStarredSnapshots() =>
      (db.select(db.snapshots)
            ..where((s) => s.starred.equals(true))
            ..orderBy([(s) => OrderingTerm.desc(s.starredAt)]))
          .watch();

  Future<void> setSnapshotStar({
    required int websiteId,
    required String timestamp,
    required String originalUrl,
    int? statusCode,
    String? mimeType,
    required bool starred,
  }) async {
    await cacheSnapshot(
      websiteId: websiteId,
      timestamp: timestamp,
      originalUrl: originalUrl,
      statusCode: statusCode,
      mimeType: mimeType,
    );
    await (db.update(db.snapshots)..where(
          (s) => s.websiteId.equals(websiteId) & s.timestamp.equals(timestamp),
        ))
        .write(
          SnapshotsCompanion(
            starred: Value(starred),
            starredAt: Value(starred ? DateTime.now() : null),
          ),
        );
  }

  // ---- search providers ----
  Stream<List<SearchProvider>> watchProviders() => (db.select(
    db.searchProviders,
  )..orderBy([(p) => OrderingTerm.asc(p.sortOrder)])).watch();

  Future<List<SearchProvider>> enabledProviders() =>
      (db.select(db.searchProviders)
            ..where((p) => p.enabled.equals(true))
            ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]))
          .get();

  Future<void> setProviderEnabled(int id, bool enabled) =>
      (db.update(db.searchProviders)..where((p) => p.id.equals(id))).write(
        SearchProvidersCompanion(enabled: Value(enabled)),
      );

  // ---- history (stored as JSON in the settings table, newest first) ----
  static const _historyKey = 'history';
  static const _historyCap = 100;

  List<HistoryEntry> _parseHistory(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = json.decode(raw) as List;
      return [for (final e in list) ?HistoryEntry.fromJson(e)];
    } catch (_) {
      return [];
    }
  }

  Stream<List<HistoryEntry>> watchHistory() =>
      (db.select(db.settings)..where((s) => s.key.equals(_historyKey)))
          .watchSingleOrNull()
          .map((row) => _parseHistory(row?.value));

  Future<void> _addHistory(HistoryEntry entry) async {
    final current = _parseHistory(await getSetting(_historyKey));
    current.removeWhere((e) => e.kind == entry.kind && e.url == entry.url);
    current.insert(0, entry);
    final trimmed = current.take(_historyCap).toList();
    await setSetting(
      _historyKey,
      json.encode([for (final e in trimmed) e.toJson()]),
    );
  }

  Future<void> recordWebsiteVisit(String url, {String? title}) => _addHistory(
    HistoryEntry(
      kind: HistoryKind.website,
      url: normalizeUrl(url),
      label: title?.isNotEmpty == true ? title! : normalizeUrl(url),
      sublabel: title?.isNotEmpty == true ? normalizeUrl(url) : null,
      visitedAt: DateTime.now(),
    ),
  );

  Future<void> recordSnapshotVisit({
    required String waybackUrl,
    required String originalUrl,
    required String timestamp,
  }) => _addHistory(
    HistoryEntry(
      kind: HistoryKind.snapshot,
      url: waybackUrl,
      label: originalUrl,
      sublabel: timestamp,
      visitedAt: DateTime.now(),
    ),
  );

  Future<void> clearHistory() => setSetting(_historyKey, null);

  // ---- recent searches (query -> chosen url), newest first ----
  static const _recentKey = 'recent_searches';
  static const _recentCap = 25;

  List<RecentSearch> _parseRecent(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      return [
        for (final e in json.decode(raw) as List) ?RecentSearch.fromJson(e),
      ];
    } catch (_) {
      return [];
    }
  }

  Stream<List<RecentSearch>> watchRecentSearches() =>
      (db.select(db.settings)..where((s) => s.key.equals(_recentKey)))
          .watchSingleOrNull()
          .map((row) => _parseRecent(row?.value));

  Future<List<RecentSearch>> recentSearches() async =>
      _parseRecent(await getSetting(_recentKey));

  Future<void> addRecentSearch(String query, String url) async {
    final q = query.trim();
    if (q.isEmpty) return;
    final list = _parseRecent(await getSetting(_recentKey));
    list.removeWhere(
      (e) => e.query.toLowerCase() == q.toLowerCase() || e.url == url,
    );
    list.insert(0, RecentSearch(query: q, url: url, at: DateTime.now()));
    await setSetting(
      _recentKey,
      json.encode([for (final e in list.take(_recentCap)) e.toJson()]),
    );
  }

  Future<void> clearRecentSearches() => setSetting(_recentKey, null);

  // ---- one-off UI hints the user can dismiss ----
  static const _shareHintKey = 'hint_share_to_open_dismissed';

  Future<bool> shareHintDismissed() async =>
      (await getSetting(_shareHintKey)) == '1';

  Future<void> dismissShareHint() => setSetting(_shareHintKey, '1');

  // ---- tab order ----
  static const _tabOrderKey = 'tab_order';

  List<String> _parseTabOrder(String? raw) {
    if (raw == null || raw.isEmpty) return List.of(kDefaultTabOrder);
    try {
      final list = (json.decode(raw) as List).map((e) => '$e').toList();
      final valid = [
        for (final t in list)
          if (kDefaultTabOrder.contains(t)) t,
      ];
      for (final t in kDefaultTabOrder) {
        if (!valid.contains(t)) valid.add(t);
      }
      return valid;
    } catch (_) {
      return List.of(kDefaultTabOrder);
    }
  }

  Stream<List<String>> watchTabOrder() =>
      (db.select(db.settings)..where((s) => s.key.equals(_tabOrderKey)))
          .watchSingleOrNull()
          .map((row) => _parseTabOrder(row?.value));

  Future<List<String>> getTabOrder() async =>
      _parseTabOrder(await getSetting(_tabOrderKey));

  Future<void> setTabOrder(List<String> order) =>
      setSetting(_tabOrderKey, json.encode(order));

  // ---- cache ----
  Future<Map<String, int>> readCache(
    int websiteId,
    String granularity, {
    Duration ttl = const Duration(hours: 12),
  }) async {
    final rows =
        await (db.select(db.cdxCache)..where(
              (c) =>
                  c.websiteId.equals(websiteId) &
                  c.granularity.equals(granularity),
            ))
            .get();
    if (rows.isEmpty) return {};
    final fresh = rows.every(
      (r) => DateTime.now().difference(r.fetchedAt) < ttl,
    );
    if (!fresh) return {};
    return {for (final r in rows) r.period: r.count};
  }

  Future<void> writeCache(
    int websiteId,
    String granularity,
    Map<String, int> counts,
  ) async {
    await db.batch((b) {
      for (final e in counts.entries) {
        b.insert(
          db.cdxCache,
          CdxCacheCompanion.insert(
            websiteId: websiteId,
            granularity: granularity,
            period: e.key,
            count: Value(e.value),
            fetchedAt: Value(DateTime.now()),
          ),
          onConflict: DoUpdate(
            (_) => CdxCacheCompanion(
              count: Value(e.value),
              fetchedAt: Value(DateTime.now()),
            ),
            target: [
              db.cdxCache.websiteId,
              db.cdxCache.granularity,
              db.cdxCache.period,
            ],
          ),
        );
      }
    });
  }

  // ---- settings ----
  Future<String?> getSetting(String key) async {
    final row = await (db.select(
      db.settings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String? value) => db
      .into(db.settings)
      .insertOnConflictUpdate(
        SettingsCompanion.insert(key: key, value: Value(value)),
      );

  Future<void> clearCache() => db.delete(db.cdxCache).go();

  Future<void> clearAllData() async {
    await db.delete(db.cdxCache).go();
    await db.delete(db.snapshots).go();
    await db.delete(db.websites).go();
    await setSetting(_historyKey, null);
    await setSetting(_recentKey, null);
  }
}
