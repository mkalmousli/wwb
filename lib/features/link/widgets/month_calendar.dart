import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/pulse.dart' show ShimmerBox;
import '../link_controller.dart';

/// A single-month calendar. Changing month is driven by drag / mouse-wheel —
/// never by a PageView — so only the visible month's data is ever requested.
class MonthCalendar extends StatefulWidget {
  const MonthCalendar({
    super.key,
    required this.year,
    required this.month,
    required this.infoOf,
    required this.countOf,
    required this.monthLoading,
    required this.monthIsEmpty,
    required this.onMonthChanged,
    required this.onDayTap,
  });

  final int year;
  final int month;
  final DayInfo Function(int y, int m, int d) infoOf;
  final int Function(int y, int m, int d) countOf;
  final bool Function(int y, int m) monthLoading;
  final bool Function(int y, int m) monthIsEmpty;
  final void Function(int y, int m) onMonthChanged;
  final void Function(DateTime day) onDayTap;

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  DateTime _lastStep = DateTime.fromMillisecondsSinceEpoch(0);
  double _wheelAccum = 0;
  Timer? _wheelReset;

  void _step(int delta) {
    if (delta == 0) return;
    if (DateTime.now().difference(_lastStep) <
        const Duration(milliseconds: 180)) {
      return;
    }
    _lastStep = DateTime.now();
    final base = DateTime(widget.year, widget.month + delta);
    widget.onMonthChanged(base.year, base.month);
  }

  void _onPointerSignal(PointerSignalEvent e) {
    if (e is! PointerScrollEvent) return;
    _wheelAccum += e.scrollDelta.dy;
    _wheelReset?.cancel();
    _wheelReset = Timer(
      const Duration(milliseconds: 120),
      () => _wheelAccum = 0,
    );
    if (_wheelAccum.abs() >= 24) {
      _step(_wheelAccum > 0 ? 1 : -1);
      _wheelAccum = 0;
    }
  }

  @override
  void dispose() {
    _wheelReset?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final monthEmpty = widget.monthIsEmpty(widget.year, widget.month);

    return Listener(
      onPointerSignal: _onPointerSignal,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragEnd: (d) {
          final v = d.primaryVelocity ?? 0;
          if (v < -220) _step(1);
          if (v > 220) _step(-1);
        },
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 130),
              child: _Grid(
                key: ValueKey('${widget.year}-${widget.month}'),
                year: widget.year,
                month: widget.month,
                monthEmpty: monthEmpty,
                infoOf: widget.infoOf,
                countOf: widget.countOf,
                onDayTap: widget.onDayTap,
              ),
            ),
            if (monthEmpty)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _BigCrossPainter(cs.error.withValues(alpha: 0.35)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BigCrossPainter extends CustomPainter {
  _BigCrossPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    const m = 18.0;
    canvas.drawLine(Offset(m, m), Offset(size.width - m, size.height - m), p);
    canvas.drawLine(Offset(size.width - m, m), Offset(m, size.height - m), p);
  }

  @override
  bool shouldRepaint(_BigCrossPainter old) => old.color != color;
}

class _Grid extends StatelessWidget {
  const _Grid({
    super.key,
    required this.year,
    required this.month,
    required this.monthEmpty,
    required this.infoOf,
    required this.countOf,
    required this.onDayTap,
  });

  final int year;
  final int month;
  final bool monthEmpty;
  final DayInfo Function(int, int, int) infoOf;
  final int Function(int, int, int) countOf;
  final void Function(DateTime) onDayTap;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leading = DateTime(year, month, 1).weekday % 7;
    final weeks = ((leading + daysInMonth) / 7).ceil();
    final cs = Theme.of(context).colorScheme;
    const labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 12),
      child: Column(
        children: [
          Row(
            children: [
              for (final l in labels)
                Expanded(
                  child: Center(
                    child: Text(
                      l,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Column(
              children: [
                for (var w = 0; w < weeks; w++)
                  Expanded(
                    child: Row(
                      children: [
                        for (var d = 0; d < 7; d++)
                          Expanded(
                            child: _cell(
                              context,
                              cs,
                              w * 7 + d - leading + 1,
                              daysInMonth,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(BuildContext context, ColorScheme cs, int day, int daysInMonth) {
    if (day < 1 || day > daysInMonth) return const SizedBox.shrink();
    final info = infoOf(year, month, day);
    final count = info == DayInfo.counted ? countOf(year, month, day) : 0;

    if (info == DayInfo.loading) {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: Stack(
          children: [
            const Positioned.fill(child: ShimmerBox()),
            _dayNumber(day, cs.onSurfaceVariant, struck: false),
          ],
        ),
      );
    }

    final noData = info == DayInfo.noData;
    // Blue ramp: more captures → deeper blue.
    final t = count <= 0 ? 0.0 : (count >= 40 ? 1.0 : count / 40);
    final Color bg;
    if (noData) {
      bg = cs.surfaceContainerHighest.withValues(alpha: 0.4);
    } else if (count > 0) {
      bg = Color.alphaBlend(
        cs.primary.withValues(alpha: 0.18 + 0.72 * t),
        cs.surface,
      );
    } else {
      bg = cs.surfaceContainerHighest;
    }
    final fg = t > 0.5 ? cs.onPrimary : cs.onSurface;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Opacity(
        opacity: noData ? 0.5 : 1,
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => onDayTap(DateTime(year, month, day)),
            child: Stack(
              children: [
                _dayNumber(
                  day,
                  noData ? cs.onSurfaceVariant : fg,
                  struck: false,
                ),
                if (noData && !monthEmpty)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _DayCrossPainter(
                          cs.onSurfaceVariant.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                  ),
                if (count > 0)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: fg,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dayNumber(int day, Color color, {required bool struck}) => Align(
    alignment: Alignment.topLeft,
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        '$day',
        style: TextStyle(
          fontSize: 12,
          color: color,
          decoration: struck ? TextDecoration.lineThrough : null,
        ),
      ),
    ),
  );
}

class _DayCrossPainter extends CustomPainter {
  _DayCrossPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final ix = size.width * 0.24;
    final iy = size.height * 0.24;
    canvas.drawLine(
      Offset(ix, iy),
      Offset(size.width - ix, size.height - iy),
      p,
    );
    canvas.drawLine(
      Offset(size.width - ix, iy),
      Offset(ix, size.height - iy),
      p,
    );
  }

  @override
  bool shouldRepaint(_DayCrossPainter old) => old.color != color;
}
