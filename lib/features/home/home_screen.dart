import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../core/app_info.dart';
import '../../core/external.dart';
import '../../core/favicon.dart';
import '../../data/local/repository.dart';
import '../../providers.dart';
import '../about/about_screen.dart';
import '../link/link_screen.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final websites = ref.watch(starredWebsitesProvider);
    final snapshots = ref.watch(starredSnapshotsProvider);
    final history = ref.watch(historyProvider);
    final order = ref.watch(tabOrderProvider).valueOrNull ?? kDefaultTabOrder;
    final repo = ref.watch(repositoryProvider);

    final tabDefs = <String, ({String label, int count, Widget view})>{
      'websites': (
        label: 'Websites',
        count: websites.valueOrNull?.length ?? 0,
        view: _WebsiteList(websites: websites, repo: repo),
      ),
      'snapshots': (
        label: 'Snapshots',
        count: snapshots.valueOrNull?.length ?? 0,
        view: _SnapshotList(snapshots: snapshots, repo: repo),
      ),
      'history': (
        label: 'History',
        count: history.valueOrNull?.length ?? 0,
        view: _HistoryList(history: history, repo: repo),
      ),
    };
    final ids = [
      for (final id in order)
        if (tabDefs.containsKey(id)) id,
    ];

    return DefaultTabController(
      length: ids.length,
      child: Scaffold(
        appBar: AppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.search),
          label: const Text('Search'),
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const SearchScreen())),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: SvgPicture.asset('assets/wwb.svg', width: 76, height: 76),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'WayWayBack',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'v$kAppVersion',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.settings, size: 18),
                  label: const Text('Settings'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('About'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TabBar(
              isScrollable: ids.length > 2,
              tabAlignment: ids.length > 2 ? TabAlignment.center : null,
              tabs: [
                for (final id in ids)
                  _CountTab(
                    label: tabDefs[id]!.label,
                    count: tabDefs[id]!.count,
                  ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [for (final id in ids) tabDefs[id]!.view],
              ),
            ),
            const SizedBox(height: 72),
          ],
        ),
      ),
    );
  }
}

class _CountTab extends StatelessWidget {
  const _CountTab({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 6),
          Container(
            constraints: const BoxConstraints(minWidth: 20),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: count == 0 ? cs.surfaceContainerHighest : cs.primary,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: count == 0 ? cs.onSurfaceVariant : cs.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebsiteList extends StatelessWidget {
  const _WebsiteList({required this.websites, required this.repo});

  final AsyncValue<List> websites;
  final dynamic repo;

  @override
  Widget build(BuildContext context) {
    return websites.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (list) {
        if (list.isEmpty) return const _Empty('No starred websites yet.');
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final w = list[i];
            return Dismissible(
              key: ValueKey('w${w.id}'),
              direction: DismissDirection.endToStart,
              background: _swipeBg(),
              onDismissed: (_) => repo.setWebsiteStar(w.id, false),
              child: ListTile(
                leading: Favicon(w.url, size: 24),
                title: Text(w.title ?? w.url),
                subtitle: w.title != null ? Text(w.url) : null,
                trailing: IconButton(
                  icon: const Icon(Icons.star, color: Colors.amber),
                  onPressed: () => repo.setWebsiteStar(w.id, false),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => LinkScreen(url: w.url)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SnapshotList extends StatelessWidget {
  const _SnapshotList({required this.snapshots, required this.repo});

  final AsyncValue<List> snapshots;
  final dynamic repo;

  @override
  Widget build(BuildContext context) {
    return snapshots.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (list) {
        if (list.isEmpty) return const _Empty('No starred snapshots yet.');
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final s = list[i];
            return Dismissible(
              key: ValueKey('s${s.id}'),
              direction: DismissDirection.endToStart,
              background: _swipeBg(),
              onDismissed: (_) => repo.setSnapshotStar(
                websiteId: s.websiteId,
                timestamp: s.timestamp,
                originalUrl: s.originalUrl,
                statusCode: s.statusCode,
                mimeType: s.mimeType,
                starred: false,
              ),
              child: ListTile(
                leading: Favicon(s.originalUrl, size: 24),
                title: Text(
                  s.originalUrl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(_fmtTs(s.timestamp)),
                trailing: IconButton(
                  icon: const Icon(Icons.star, color: Colors.amber),
                  onPressed: () => repo.setSnapshotStar(
                    websiteId: s.websiteId,
                    timestamp: s.timestamp,
                    originalUrl: s.originalUrl,
                    statusCode: s.statusCode,
                    mimeType: s.mimeType,
                    starred: false,
                  ),
                ),
                onTap: () => openExternal(
                  context,
                  'https://web.archive.org/web/${s.timestamp}/${s.originalUrl}',
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.history, required this.repo});

  final AsyncValue<List<HistoryEntry>> history;
  final dynamic repo;

  @override
  Widget build(BuildContext context) {
    return history.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (list) {
        if (list.isEmpty) return const _Empty('Nothing visited yet.');
        return Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.delete_sweep, size: 18),
                label: const Text('Clear'),
                onPressed: repo.clearHistory,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final h = list[i];
                  final isSnap = h.kind == HistoryKind.snapshot;
                  return ListTile(
                    leading: Favicon(isSnap ? h.label : h.url, size: 22),
                    title: Text(
                      h.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      [
                        if (h.sublabel != null)
                          isSnap ? _fmtTs(h.sublabel!) : h.sublabel!,
                        _ago(h.visitedAt),
                      ].join('  ·  '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      isSnap ? Icons.history : Icons.public,
                      size: 18,
                      color: Theme.of(context).hintColor,
                    ),
                    onTap: () {
                      if (isSnap) {
                        openExternal(context, h.url);
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LinkScreen(url: h.url),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _swipeBg() => Container(
  alignment: Alignment.centerRight,
  padding: const EdgeInsets.only(right: 20),
  color: Colors.red.shade400,
  child: const Icon(Icons.star_border, color: Colors.white),
);

String _fmtTs(String ts) {
  try {
    final d = DateTime(
      int.parse(ts.substring(0, 4)),
      int.parse(ts.substring(4, 6)),
      int.parse(ts.substring(6, 8)),
      int.parse(ts.substring(8, 10)),
      int.parse(ts.substring(10, 12)),
    );
    return DateFormat('yyyy-MM-dd HH:mm').format(d);
  } catch (_) {
    return ts;
  }
}

String _ago(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'just now';
  if (d.inMinutes < 60) return '${d.inMinutes}m ago';
  if (d.inHours < 24) return '${d.inHours}h ago';
  if (d.inDays < 7) return '${d.inDays}d ago';
  return DateFormat('yyyy-MM-dd').format(t);
}

class _Empty extends StatelessWidget {
  const _Empty(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(text, style: TextStyle(color: Theme.of(context).hintColor)),
  );
}
