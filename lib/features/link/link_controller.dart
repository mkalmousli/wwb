import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_log.dart';
import '../../data/local/repository.dart';
import '../../data/wayback/wb_calendar.dart';
import '../../providers.dart';

/// What is known about a single day cell.
enum DayInfo { loading, noData, counted }

@immutable
class LinkState {
  const LinkState({
    required this.websiteId,
    required this.url,
    required this.selectedYear,
    required this.selectedMonth,
    this.yearsWithData = const {},
    this.monthsWithData = const {},
    this.sparklineLoaded = false,
    this.loadingSparkline = true,
    this.dayCounts = const {},
    this.yearsCountsLoaded = const {},
    this.loadingYearDays = const {},
    this.log = const [],
    this.requestCount = 0,
    this.totalBytes = 0,
    this.opStartedAt,
    this.currentOp,
  });

  final int websiteId;
  final String url;
  final int selectedYear;
  final int selectedMonth;

  final Set<int> yearsWithData;
  final Set<String> monthsWithData; // 'YYYYMM'
  final bool sparklineLoaded;
  final bool loadingSparkline;

  final Map<String, int> dayCounts; // 'YYYYMMDD' -> count
  final Set<int> yearsCountsLoaded; // years whose day counts are loaded
  final Set<int> loadingYearDays;

  final List<ApiLogEntry> log;
  final int requestCount;
  final int totalBytes;
  final DateTime? opStartedAt;
  final String? currentOp;

  bool get busy => loadingSparkline || loadingYearDays.isNotEmpty;

  String _mk(int y, int m) => '$y${m.toString().padLeft(2, '0')}';
  String _dk(int y, int m, int d) =>
      '${_mk(y, m)}${d.toString().padLeft(2, '0')}';

  bool yearHasData(int y) => yearsWithData.contains(y);
  bool monthHasData(int y, int m) => monthsWithData.contains(_mk(y, m));
  bool yearDaysLoaded(int y) => yearsCountsLoaded.contains(y);

  /// The sparkline already knows which years/months are empty — treat those as
  /// resolved without ever making a calendar request.
  bool _knownEmptyMonth(int y, int m) =>
      sparklineLoaded && !monthsWithData.contains(_mk(y, m));

  bool _monthHasAnyCount(int y, int m) {
    final mk = _mk(y, m);
    return dayCounts.keys.any((k) => k.startsWith(mk));
  }

  bool monthLoading(int y, int m) =>
      !yearsCountsLoaded.contains(y) &&
      !_knownEmptyMonth(y, m) &&
      !_monthHasAnyCount(y, m);

  /// True only once we know for certain the month has zero captures.
  bool monthEmpty(int y, int m) {
    if (monthLoading(y, m)) return false;
    if (monthsWithData.contains(_mk(y, m))) return false;
    return !_monthHasAnyCount(y, m);
  }

  int exactDayCount(int y, int m, int d) => dayCounts[_dk(y, m, d)] ?? -1;

  DayInfo dayInfo(int y, int m, int d) {
    if (dayCounts.containsKey(_dk(y, m, d))) return DayInfo.counted;
    if (yearsCountsLoaded.contains(y) || _knownEmptyMonth(y, m)) {
      return DayInfo.noData;
    }
    return DayInfo.loading;
  }

  LinkState copyWith({
    int? selectedYear,
    int? selectedMonth,
    Set<int>? yearsWithData,
    Set<String>? monthsWithData,
    bool? sparklineLoaded,
    bool? loadingSparkline,
    Map<String, int>? dayCounts,
    Set<int>? yearsCountsLoaded,
    Set<int>? loadingYearDays,
    List<ApiLogEntry>? log,
    int? requestCount,
    int? totalBytes,
    DateTime? opStartedAt,
    String? currentOp,
    bool clearOp = false,
  }) => LinkState(
    websiteId: websiteId,
    url: url,
    selectedYear: selectedYear ?? this.selectedYear,
    selectedMonth: selectedMonth ?? this.selectedMonth,
    yearsWithData: yearsWithData ?? this.yearsWithData,
    monthsWithData: monthsWithData ?? this.monthsWithData,
    sparklineLoaded: sparklineLoaded ?? this.sparklineLoaded,
    loadingSparkline: loadingSparkline ?? this.loadingSparkline,
    dayCounts: dayCounts ?? this.dayCounts,
    yearsCountsLoaded: yearsCountsLoaded ?? this.yearsCountsLoaded,
    loadingYearDays: loadingYearDays ?? this.loadingYearDays,
    log: log ?? this.log,
    requestCount: requestCount ?? this.requestCount,
    totalBytes: totalBytes ?? this.totalBytes,
    opStartedAt: clearOp ? null : (opStartedAt ?? this.opStartedAt),
    currentOp: clearOp ? null : (currentOp ?? this.currentOp),
  );
}

class LinkController extends StateNotifier<LinkState> {
  LinkController(this._ref, int websiteId, String url)
    : super(
        LinkState(
          websiteId: websiteId,
          url: url,
          selectedYear: DateTime.now().year,
          selectedMonth: DateTime.now().month,
        ),
      ) {
    _init();
  }

  final Ref _ref;
  WbCalendarApi get _cal => _ref.read(wbCalendarProvider);
  Repository get _repo => _ref.read(repositoryProvider);

  static final _byteCountRe = RegExp(r'(\d+) bytes');
  Timer? _navDebounce;

  void _log(String message, {bool error = false, bool done = false}) {
    if (!mounted) return;
    final next = [...state.log, ApiLogEntry(message, error: error, done: done)];
    if (next.length > 300) next.removeRange(0, next.length - 300);
    var reqs = state.requestCount;
    var bytes = state.totalBytes;
    if (message.startsWith('GET ')) reqs++;
    final bm = _byteCountRe.firstMatch(message);
    if (bm != null && message.contains('←')) {
      bytes += int.tryParse(bm.group(1)!) ?? 0;
    }
    state = state.copyWith(log: next, requestCount: reqs, totalBytes: bytes);
  }

  ApiLog get _apiLog =>
      (m, {bool error = false, bool done = false}) =>
          _log(m, error: error, done: done);

  void _beginOp(String label) {
    state = state.copyWith(opStartedAt: DateTime.now(), currentOp: label);
    _log(label);
  }

  void _init() {
    loadSparkline();
    loadYearDays(state.selectedYear);
  }

  // ---- sparkline: which years / months have captures ----
  Future<void> loadSparkline({bool force = false}) async {
    state = state.copyWith(loadingSparkline: true);
    if (force) {
      state = state.copyWith(
        yearsWithData: {},
        monthsWithData: {},
        sparklineLoaded: false,
      );
    }
    _beginOp('Sparkline · ${state.url}');
    try {
      final cached = force
          ? <String, int>{}
          : await _repo.readCache(state.websiteId, 'sparkline');
      Map<int, List<int>> spark;
      if (cached.isNotEmpty) {
        // cached as 'YYYYMM' -> count
        spark = {};
        for (final e in cached.entries) {
          final y = int.parse(e.key.substring(0, 4));
          final m = int.parse(e.key.substring(4, 6));
          (spark[y] ??= List<int>.filled(12, 0))[m - 1] = e.value;
        }
        _log('Loaded sparkline from cache · ${spark.length} years', done: true);
      } else {
        spark = await _cal.sparkline(state.url, log: _apiLog);
        final flat = <String, int>{};
        spark.forEach((y, months) {
          for (var i = 0; i < months.length && i < 12; i++) {
            if (months[i] > 0) {
              flat['$y${(i + 1).toString().padLeft(2, '0')}'] = months[i];
            }
          }
        });
        await _repo.writeCache(state.websiteId, 'sparkline', flat);
      }
      if (!mounted) return;
      final years = <int>{};
      final monthsSet = <String>{};
      spark.forEach((y, months) {
        var any = false;
        for (var i = 0; i < months.length && i < 12; i++) {
          if (months[i] > 0) {
            any = true;
            monthsSet.add('$y${(i + 1).toString().padLeft(2, '0')}');
          }
        }
        if (any) years.add(y);
      });
      state = state.copyWith(
        yearsWithData: years,
        monthsWithData: monthsSet,
        sparklineLoaded: true,
        loadingSparkline: false,
        clearOp: true,
      );
    } catch (e) {
      _log('Could not load sparkline: $e', error: true);
      if (mounted) {
        state = state.copyWith(loadingSparkline: false, clearOp: true);
      }
    }
  }

  // ---- per-year day counts (covers all 12 months in one request) ----
  Future<void> loadYearDays(int year, {bool force = false}) async {
    if (!force && state.yearsCountsLoaded.contains(year)) return;
    if (state.loadingYearDays.contains(year)) return;
    // Smart: the sparkline already told us this year is empty — don't ask.
    if (!force &&
        state.sparklineLoaded &&
        !state.yearsWithData.contains(year)) {
      _log('$year has no captures (sparkline) — no request needed', done: true);
      state = state.copyWith(
        yearsCountsLoaded: {...state.yearsCountsLoaded, year},
      );
      return;
    }
    state = state.copyWith(loadingYearDays: {...state.loadingYearDays, year});
    _beginOp('Calendar · $year');
    try {
      final key = 'yeardays-$year';
      var counts = force
          ? <String, int>{}
          : await _repo.readCache(state.websiteId, key);
      if (counts.isNotEmpty) {
        _log(
          'Loaded $year calendar from cache · ${counts.length} days',
          done: true,
        );
      } else {
        counts = await _cal.yearDayCounts(state.url, year, log: _apiLog);
        await _repo.writeCache(state.websiteId, key, counts);
      }
      if (!mounted) return;
      state = state.copyWith(
        dayCounts: {...state.dayCounts, ...counts},
        yearsCountsLoaded: {...state.yearsCountsLoaded, year},
        loadingYearDays: {...state.loadingYearDays}..remove(year),
        clearOp: true,
      );
    } catch (e) {
      _log('Could not load $year calendar: $e', error: true);
      if (mounted) {
        state = state.copyWith(
          loadingYearDays: {...state.loadingYearDays}..remove(year),
          clearOp: true,
        );
      }
    }
  }

  void _debounced(int year) {
    _navDebounce?.cancel();
    // Empty years resolve instantly with no request or debounce.
    if (state.sparklineLoaded && !state.yearsWithData.contains(year)) {
      loadYearDays(year);
      return;
    }
    _navDebounce = Timer(const Duration(milliseconds: 200), () {
      if (mounted) loadYearDays(year);
    });
  }

  void selectYear(int year) {
    if (year == state.selectedYear) return;
    state = state.copyWith(selectedYear: year);
    _debounced(year);
  }

  void selectMonth(int month) {
    if (month == state.selectedMonth) return;
    // No request needed — the whole year's day counts are already loaded.
    state = state.copyWith(selectedMonth: month);
  }

  void selectYearMonth(int year, int month) {
    if (year == state.selectedYear && month == state.selectedMonth) return;
    final yearChanged = year != state.selectedYear;
    state = state.copyWith(selectedYear: year, selectedMonth: month);
    if (yearChanged) _debounced(year);
  }

  Future<void> refresh() async {
    _log('Refreshing…');
    await Future.wait([
      loadSparkline(force: true),
      loadYearDays(state.selectedYear, force: true),
    ]);
  }

  @override
  void dispose() {
    _navDebounce?.cancel();
    super.dispose();
  }
}

typedef LinkArg = ({int websiteId, String url});

final linkControllerProvider = StateNotifierProvider.autoDispose
    .family<LinkController, LinkState, LinkArg>(
      (ref, arg) => LinkController(ref, arg.websiteId, arg.url),
    );
