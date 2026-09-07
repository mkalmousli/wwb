import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/favicon.dart';
import '../../data/local/repository.dart';
import '../../providers.dart';
import '../day/day_page.dart';
import 'link_controller.dart';
import 'widgets/month_calendar.dart';
import 'widgets/request_details_dialog.dart';
import 'widgets/scroll_selector.dart';

final _websiteProvider = StreamProvider.autoDispose.family(
  (ref, int id) => ref.watch(repositoryProvider).watchWebsite(id),
);

class LinkScreen extends ConsumerStatefulWidget {
  const LinkScreen({super.key, required this.url});

  final String url;

  @override
  ConsumerState<LinkScreen> createState() => _LinkScreenState();
}

class _LinkScreenState extends ConsumerState<LinkScreen> {
  int? _websiteId;
  late final String _url = normalizeUrl(widget.url);

  @override
  void initState() {
    super.initState();
    _ensureWebsite();
  }

  Future<void> _ensureWebsite() async {
    final repo = ref.read(repositoryProvider);
    final w = await repo.upsertWebsite(_url);
    await repo.recordWebsiteVisit(_url, title: w.title);
    if (mounted) setState(() => _websiteId = w.id);
  }

  void _openDetails(LinkArg arg) {
    showDialog(
      context: context,
      builder: (_) => RequestDetailsDialog(
        read: () => ref.read(linkControllerProvider(arg)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = _websiteId;
    if (id == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final arg = (websiteId: id, url: _url);
    final state = ref.watch(linkControllerProvider(arg));
    final controller = ref.read(linkControllerProvider(arg).notifier);
    final repo = ref.watch(repositoryProvider);
    final website = ref.watch(_websiteProvider(id));
    final cs = Theme.of(context).colorScheme;

    final years = [for (var y = 1996; y <= DateTime.now().year + 1; y++) y];
    final months = [for (var m = 1; m <= 12; m++) m];
    final sk = state.sparklineLoaded;

    Widget yearPicker(Axis axis) => ScrollSelector(
      axis: axis,
      values: years,
      selected: state.selectedYear,
      loading: state.loadingSparkline,
      onChanged: controller.selectYear,
      labelOf: (y) => '$y',
      dataStateOf: (y) => sk ? state.yearHasData(y) : null,
      extent: axis == Axis.horizontal ? 78 : 46,
    );

    Widget monthPicker(Axis axis) => ScrollSelector(
      axis: axis,
      values: months,
      selected: state.selectedMonth,
      loading:
          state.loadingSparkline ||
          state.loadingYearDays.contains(state.selectedYear),
      onChanged: controller.selectMonth,
      labelOf: (m) => DateFormat('MMM').format(DateTime(2000, m)),
      dataStateOf: (m) => sk ? state.monthHasData(state.selectedYear, m) : null,
      extent: axis == Axis.horizontal ? 68 : 46,
    );

    final calendar = MonthCalendar(
      year: state.selectedYear,
      month: state.selectedMonth,
      infoOf: state.dayInfo,
      countOf: (y, m, d) => state.exactDayCount(y, m, d),
      monthLoading: state.monthLoading,
      monthIsEmpty: state.monthEmpty,
      onMonthChanged: controller.selectYearMonth,
      onDayTap: (day) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DayPage(websiteId: id, url: _url, day: day),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Favicon(_url, size: 22),
            const SizedBox(width: 8),
            const Text('WayWayBack'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: state.busy ? null : controller.refresh,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 8, 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _url,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                website.maybeWhen(
                  data: (w) {
                    final starred = w?.starred ?? false;
                    return IconButton(
                      icon: Icon(
                        starred ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () => repo.setWebsiteStar(id, !starred),
                    );
                  },
                  orElse: () => const SizedBox(width: 48),
                ),
              ],
            ),
          ),
          _StatusBar(
            state: state,
            onTap: () => _openDetails(arg),
            onRetry: controller.refresh,
          ),
          const Divider(height: 1),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth >= 640;
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(width: 116, child: yearPicker(Axis.vertical)),
                      const VerticalDivider(width: 1),
                      SizedBox(width: 104, child: monthPicker(Axis.vertical)),
                      const VerticalDivider(width: 1),
                      Expanded(child: calendar),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 66,
                      color: cs.surfaceContainerLow,
                      child: yearPicker(Axis.horizontal),
                    ),
                    const Divider(height: 1),
                    Container(
                      height: 66,
                      color: cs.surfaceContainerLow,
                      child: monthPicker(Axis.horizontal),
                    ),
                    const Divider(height: 1),
                    Expanded(child: calendar),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({
    required this.state,
    required this.onTap,
    required this.onRetry,
  });

  final LinkState state;
  final VoidCallback onTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final last = state.log.isNotEmpty ? state.log.last : null;
    final failed = !state.busy && (last?.error ?? false);
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.busy)
            const LinearProgressIndicator(minHeight: 2)
          else
            const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: state.busy
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : Icon(
                          Icons.cloud_done_outlined,
                          size: 16,
                          color: cs.primary,
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    last?.message ??
                        (state.busy
                            ? 'Contacting the Wayback Machine…'
                            : 'Tap for network details'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: last?.error == true
                          ? cs.error
                          : Theme.of(context).hintColor,
                    ),
                  ),
                ),
                if (failed)
                  TextButton(
                    onPressed: onRetry,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 32),
                    ),
                    child: const Text('Retry'),
                  )
                else
                  Text(
                    '${state.requestCount} req',
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                const SizedBox(width: 6),
                Icon(Icons.info_outline, size: 16, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
