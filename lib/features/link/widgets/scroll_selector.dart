import 'dart:async';

import 'package:flutter/material.dart';

/// A reliable snapping selector (vertical or horizontal). Uses a plain
/// [ListView] so mouse-wheel and trackpad scrolling work smoothly on desktop,
/// then snaps to the nearest item when the scroll settles.
class ScrollSelector extends StatefulWidget {
  const ScrollSelector({
    super.key,
    required this.axis,
    required this.values,
    required this.selected,
    required this.onChanged,
    required this.labelOf,
    required this.dataStateOf,
    this.loading = false,
    this.extent = 44,
  });

  final Axis axis;
  final List<int> values;
  final int selected;
  final ValueChanged<int> onChanged;
  final String Function(int) labelOf;

  /// `true` → has archived data (rendered blue); `false` → no data (dimmed +
  /// strikethrough); `null` → not known yet (neutral).
  final bool? Function(int) dataStateOf;
  final bool loading;
  final double extent;

  @override
  State<ScrollSelector> createState() => _ScrollSelectorState();
}

class _ScrollSelectorState extends State<ScrollSelector> {
  final _ctrl = ScrollController();
  Timer? _settle;
  bool _userScrolling = false;
  int? _preview; // index highlighted while scrolling (before commit)
  DateTime _lastSettle = DateTime.fromMillisecondsSinceEpoch(0);
  double _pad = 0;

  int get _selIndex {
    final i = widget.values.indexOf(widget.selected);
    return i < 0 ? 0 : i;
  }

  double _offsetFor(int index) => index * widget.extent;

  @override
  void didUpdateWidget(ScrollSelector old) {
    super.didUpdateWidget(old);
    if (_userScrolling) return;
    if (old.selected != widget.selected && _ctrl.hasClients) {
      final target = _offsetFor(
        _selIndex,
      ).clamp(0.0, _ctrl.position.maxScrollExtent);
      if ((_ctrl.offset - target).abs() > 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _ctrl.hasClients && !_userScrolling) {
            _ctrl.animateTo(
              target,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _settle?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  int _nearestIndex() {
    final raw = _ctrl.offset / widget.extent;
    return raw.round().clamp(0, widget.values.length - 1);
  }

  void _onScrollEnd() {
    _settle?.cancel();
    _settle = Timer(const Duration(milliseconds: 80), () {
      if (!mounted || !_ctrl.hasClients) return;
      final i = _nearestIndex();
      final target = _offsetFor(i).clamp(0.0, _ctrl.position.maxScrollExtent);
      if ((_ctrl.offset - target).abs() > 0.5) {
        _ctrl.animateTo(
          target,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
        );
      }
      _userScrolling = false;
      _lastSettle = DateTime.now();
      setState(() => _preview = null);
      if (widget.values[i] != widget.selected) {
        widget.onChanged(widget.values[i]);
      }
    });
  }

  bool _onNotification(ScrollNotification n) {
    if (n is ScrollStartNotification) {
      _userScrolling = true;
      _settle?.cancel();
    } else if (n is ScrollUpdateNotification) {
      _userScrolling = true;
      // local highlight only — the network fetch waits for settle
      final i = _nearestIndex();
      if (_preview != i) setState(() => _preview = i);
    } else if (n is ScrollEndNotification) {
      _onScrollEnd();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (widget.values.isEmpty) return const SizedBox.shrink();
    final vertical = widget.axis == Axis.vertical;

    return LayoutBuilder(
      builder: (context, c) {
        final viewport = vertical ? c.maxHeight : c.maxWidth;
        _pad = ((viewport - widget.extent) / 2).clamp(0.0, viewport);

        // keep the controller aligned after first layout
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_ctrl.hasClients || _userScrolling) return;
          if (DateTime.now().difference(_lastSettle) <
              const Duration(milliseconds: 350)) {
            return; // don't fight the settle animation
          }
          final t = _offsetFor(
            _selIndex,
          ).clamp(0.0, _ctrl.position.maxScrollExtent);
          if ((_ctrl.offset - t).abs() > 1) _ctrl.jumpTo(t);
        });

        return Stack(
          alignment: Alignment.center,
          children: [
            IgnorePointer(
              child: Container(
                width: vertical ? null : widget.extent + 8,
                height: vertical ? widget.extent : null,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.45)),
                ),
              ),
            ),
            NotificationListener<ScrollNotification>(
              onNotification: _onNotification,
              child: ListView.builder(
                controller: _ctrl,
                scrollDirection: widget.axis,
                physics: const ClampingScrollPhysics(),
                padding: vertical
                    ? EdgeInsets.symmetric(vertical: _pad)
                    : EdgeInsets.symmetric(horizontal: _pad),
                itemExtent: widget.extent,
                itemCount: widget.values.length,
                itemBuilder: (context, i) {
                  final v = widget.values[i];
                  final highlightIndex = _preview ?? _selIndex;
                  final sel = i == highlightIndex;
                  final ds = widget.dataStateOf(v); // true / false / null
                  final noData = ds == false;
                  final hasData = ds == true;
                  final Color color = sel
                      ? cs.primary
                      : noData
                      ? cs.onSurface.withValues(alpha: 0.34)
                      : hasData
                      ? cs.primary.withValues(alpha: 0.85)
                      : cs.onSurface.withValues(alpha: 0.6);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _userScrolling = false;
                      _ctrl.animateTo(
                        _offsetFor(
                          i,
                        ).clamp(0.0, _ctrl.position.maxScrollExtent),
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                      );
                      if (v != widget.selected) widget.onChanged(v);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                widget.labelOf(v),
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: sel ? 18 : 15,
                                  fontWeight: sel || hasData
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: color,
                                ),
                              ),
                            ),
                          ),
                          if (noData)
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _CrossPainter(
                                  cs.error.withValues(alpha: 0.85),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.loading)
              Positioned(
                right: vertical ? 3 : null,
                top: vertical ? null : 3,
                child: const _PulseDot(),
              ),
          ],
        );
      },
    );
  }
}

class _CrossPainter extends CustomPainter {
  _CrossPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final inset = size.width * 0.12;
    canvas.drawLine(
      Offset(inset, size.height * 0.15),
      Offset(size.width - inset, size.height * 0.85),
      p,
    );
    canvas.drawLine(
      Offset(size.width - inset, size.height * 0.15),
      Offset(inset, size.height * 0.85),
      p,
    );
  }

  @override
  bool shouldRepaint(_CrossPainter old) => old.color != color;
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FadeTransition(
      opacity: Tween(begin: 0.25, end: 1.0).animate(_c),
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
      ),
    );
  }
}
