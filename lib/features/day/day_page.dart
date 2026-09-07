import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/api_log.dart';
import '../../core/elapsed.dart';
import '../../core/external.dart';
import '../../core/favicon.dart';
import '../../data/wayback/wayback_models.dart';
import '../../providers.dart';

class DayPage extends ConsumerStatefulWidget {
  const DayPage({
    super.key,
    required this.websiteId,
    required this.url,
    required this.day,
  });

  final int websiteId;
  final String url;
  final DateTime day;

  @override
  ConsumerState<DayPage> createState() => _DayPageState();
}

class _DayPageState extends ConsumerState<DayPage> {
  final _log = <ApiLogEntry>[];
  List<WaybackSnapshot>? _snaps;
  String? _error;
  bool _loading = true;
  DateTime _startedAt = DateTime.now();
  Timer? _timer;

  // Optional time-of-day filters (null = any).
  int? _fHour;
  int? _fMinute;
  int? _fSecond;

  bool get _hasFilter => _fHour != null || _fMinute != null || _fSecond != null;

  List<WaybackSnapshot> _apply(List<WaybackSnapshot> list) => list.where((s) {
    final t = s.dateTime;
    if (_fHour != null && t.hour != _fHour) return false;
    if (_fMinute != null && t.minute != _fMinute) return false;
    if (_fSecond != null && t.second != _fSecond) return false;
    return true;
  }).toList();

  /// Only offer times that actually exist, cascading: minutes are limited to
  /// the chosen hour, seconds to the chosen hour+minute.
  List<int> get _hours {
    final s = {
      for (final x in _snaps ?? const <WaybackSnapshot>[]) x.dateTime.hour,
    };
    return s.toList()..sort();
  }

  List<int> get _minutes {
    final s = {
      for (final x in _snaps ?? const <WaybackSnapshot>[])
        if (_fHour == null || x.dateTime.hour == _fHour) x.dateTime.minute,
    };
    return s.toList()..sort();
  }

  List<int> get _seconds {
    final s = {
      for (final x in _snaps ?? const <WaybackSnapshot>[])
        if ((_fHour == null || x.dateTime.hour == _fHour) &&
            (_fMinute == null || x.dateTime.minute == _fMinute))
          x.dateTime.second,
    };
    return s.toList()..sort();
  }

  void _setFilter({int? h, int? m, int? sec, bool clear = false}) {
    setState(() {
      if (clear) {
        _fHour = _fMinute = _fSecond = null;
        return;
      }
      _fHour = h;
      _fMinute = m;
      _fSecond = sec;
      // Drop now-impossible narrower selections.
      if (_fHour != null && !_minutes.contains(_fMinute)) _fMinute = null;
      if (!_seconds.contains(_fSecond)) _fSecond = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _snaps = null;
      _error = null;
      _loading = true;
      _log.clear();
      _startedAt = DateTime.now();
    });
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => setState(() {}),
    );
    try {
      final snaps = await ref
          .read(wbCalendarProvider)
          .daySnapshots(
            widget.url,
            widget.day,
            log: (m, {error = false, done = false}) {
              if (mounted) {
                setState(
                  () => _log.add(ApiLogEntry(m, error: error, done: done)),
                );
              }
            },
          );
      if (mounted) setState(() => _snaps = snaps);
    } catch (e) {
      if (mounted && _snaps == null) setState(() => _error = '$e');
    } finally {
      _timer?.cancel();
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(repositoryProvider);
    final starred = ref.watch(starredSnapshotsProvider).valueOrNull ?? [];
    final starredKeys = {for (final s in starred) s.timestamp};
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Favicon(widget.url, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                DateFormat('EEE, d MMM yyyy').format(widget.day),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (_snaps != null && _snaps!.isNotEmpty)
            IconButton(
              tooltip: 'Share day',
              icon: const Icon(Icons.ios_share),
              onPressed: () => Share.share(
                'Archived snapshots of ${widget.url} on '
                '${DateFormat('yyyy-MM-dd').format(widget.day)}:\n'
                'https://web.archive.org/web/'
                '${DateFormat('yyyyMMdd').format(widget.day)}/${widget.url}',
              ),
            ),
        ],
      ),
      body: _error != null
          ? _errorView(cs)
          : _snaps == null
          ? _loadingView(cs)
          : _list(repo, starredKeys, cs),
    );
  }

  Widget _loadingView(ColorScheme cs) {
    final elapsed = DateTime.now().difference(_startedAt);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Fetching snapshots · ${fmtElapsed(elapsed)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                _log.isNotEmpty ? _log.last.message : 'Preparing request…',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final e in _log)
                    Text(
                      '+${fmtElapsed(e.at.difference(_startedAt))}  ${e.message}',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontFamily: 'monospace',
                        color: e.error ? cs.error : cs.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorView(ColorScheme cs) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cloud_off, size: 40, color: cs.error),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Failed to load snapshots:\n$_error',
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
          onPressed: _load,
        ),
      ],
    ),
  );

  Widget _list(dynamic repo, Set<String> starredKeys, ColorScheme cs) {
    final all = _snaps!;
    final list = _hasFilter ? _apply(all) : all;
    return Column(
      children: [
        if (_loading) const LinearProgressIndicator(minHeight: 2),
        Container(
          width: double.infinity,
          color: cs.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _loading
                      ? '${all.length} so far · ${_log.isNotEmpty ? _log.last.message : "loading…"}'
                      : _hasFilter
                      ? '${list.length} of ${all.length} snapshot(s)'
                      : '${all.length} snapshot(s) · loaded in '
                            '${fmtElapsed((_log.isNotEmpty ? _log.last.at : DateTime.now()).difference(_startedAt))}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
              ),
              if (_loading)
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
        ),
        if (_hours.length > 1 || _hasFilter)
          _FilterBar(
            hour: _fHour,
            minute: _fMinute,
            second: _fSecond,
            hours: _hours,
            minutes: _minutes,
            seconds: _seconds,
            onHour: (v) => _setFilter(h: v, m: _fMinute, sec: _fSecond),
            onMinute: (v) => _setFilter(h: _fHour, m: v, sec: _fSecond),
            onSecond: (v) => _setFilter(h: _fHour, m: _fMinute, sec: v),
            onClear: () => _setFilter(clear: true),
          ),
        const Divider(height: 1),
        if (list.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                _hasFilter
                    ? 'No snapshots match the filter.'
                    : 'No snapshots captured this day.',
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, i) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final s = list[i];
                final isStarred = starredKeys.contains(s.timestamp);
                return ListTile(
                  title: Text(DateFormat('HH:mm:ss').format(s.dateTime)),
                  subtitle: Text(
                    [
                      if (s.statusCode != null) 'HTTP ${s.statusCode}',
                      if (s.mimeType != null && s.mimeType!.isNotEmpty)
                        s.mimeType,
                    ].join('  ·  '),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Share',
                        icon: const Icon(Icons.ios_share),
                        onPressed: () => Share.share(s.waybackUrl),
                      ),
                      IconButton(
                        tooltip: isStarred ? 'Unstar' : 'Star',
                        icon: Icon(
                          isStarred ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => repo.setSnapshotStar(
                          websiteId: widget.websiteId,
                          timestamp: s.timestamp,
                          originalUrl: s.original,
                          statusCode: s.statusCode,
                          mimeType: s.mimeType,
                          starred: !isStarred,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    repo.recordSnapshotVisit(
                      waybackUrl: s.waybackUrl,
                      originalUrl: s.original,
                      timestamp: s.timestamp,
                    );
                    openExternal(context, s.waybackUrl);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.hour,
    required this.minute,
    required this.second,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.onHour,
    required this.onMinute,
    required this.onSecond,
    required this.onClear,
  });

  final int? hour;
  final int? minute;
  final int? second;
  final List<int> hours;
  final List<int> minutes;
  final List<int> seconds;
  final ValueChanged<int?> onHour;
  final ValueChanged<int?> onMinute;
  final ValueChanged<int?> onSecond;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final any = hour == null && minute == null && second == null;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.filter_alt_outlined, size: 18),
          const SizedBox(width: 8),
          _dropdown('Hour', hours, hour, onHour),
          const SizedBox(width: 8),
          // Minutes only matter once an hour (or fewer minute options) is in play.
          if (hour != null || minutes.length > 1) ...[
            _dropdown('Min', minutes, minute, onMinute),
            const SizedBox(width: 8),
          ],
          if ((hour != null && minute != null) || seconds.length > 1) ...[
            _dropdown('Sec', seconds, second, onSecond),
            const SizedBox(width: 8),
          ],
          TextButton(
            onPressed: any ? null : onClear,
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
    String label,
    List<int> options,
    int? value,
    ValueChanged<int?> onSet,
  ) {
    final safe = options.contains(value) ? value : null;
    return DropdownButton<int?>(
      value: safe,
      hint: Text(label),
      isDense: true,
      underline: const SizedBox.shrink(),
      items: [
        DropdownMenuItem<int?>(value: null, child: Text('$label: any')),
        for (final i in options)
          DropdownMenuItem<int?>(
            value: i,
            child: Text('$label ${i.toString().padLeft(2, '0')}'),
          ),
      ],
      onChanged: onSet,
    );
  }
}
