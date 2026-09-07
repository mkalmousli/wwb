import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/api_log.dart';
import '../../../core/elapsed.dart';
import '../link_controller.dart';

/// A live, highly visual view of what the app is doing on the network.
class RequestDetailsDialog extends StatefulWidget {
  const RequestDetailsDialog({super.key, required this.read});

  final LinkState Function() read;

  @override
  State<RequestDetailsDialog> createState() => _RequestDetailsDialogState();
}

class _RequestDetailsDialogState extends State<RequestDetailsDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 400),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _bytes(int b) => b < 1024
      ? '$b B'
      : b < 1024 * 1024
      ? '${(b / 1024).toStringAsFixed(1)} KB'
      : '${(b / 1024 / 1024).toStringAsFixed(2)} MB';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final s = widget.read();
    final busy = s.busy;
    final started = s.opStartedAt;
    final opElapsed = started == null
        ? null
        : DateTime.now().difference(started);
    final first = s.log.isNotEmpty ? s.log.first.at : null;
    final total = first == null ? null : DateTime.now().difference(first);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
              child: Row(
                children: [
                  _Beacon(active: busy, color: cs.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Network activity',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // ---- current operation ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          busy ? Icons.downloading : Icons.check_circle,
                          size: 18,
                          color: cs.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            busy
                                ? (s.currentOp ?? 'Working…')
                                : 'Idle — nothing in flight',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (busy && opElapsed != null)
                          Text(
                            fmtElapsed(opElapsed),
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (busy)
                      const _IndeterminateBar()
                    else
                      Text(
                        'Tap a request below for details.',
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _Meter(
                          icon: Icons.swap_vert,
                          label: 'Requests',
                          value: '${s.requestCount}',
                        ),
                        const SizedBox(width: 16),
                        _Meter(
                          icon: Icons.download,
                          label: 'Downloaded',
                          value: _bytes(s.totalBytes),
                        ),
                        const SizedBox(width: 16),
                        if (total != null)
                          _Meter(
                            icon: Icons.timer_outlined,
                            label: 'Session',
                            value: fmtElapsed(total),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Timeline',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${s.log.length} events',
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Divider(height: 1),
            Expanded(
              child: s.log.isEmpty
                  ? const Center(child: Text('No activity yet.'))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 6, 16, 12),
                      itemCount: s.log.length,
                      itemBuilder: (_, i) {
                        final e = s.log[s.log.length - 1 - i];
                        final rel = first == null
                            ? ''
                            : '+${fmtElapsed(e.at.difference(first))}';
                        return _LogRow(entry: e, rel: rel);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _Kind { request, response, retry, error, done, info }

_Kind _kindOf(ApiLogEntry e) {
  if (e.error) return e.message.contains('retry') ? _Kind.retry : _Kind.error;
  if (e.done) return _Kind.done;
  final m = e.message;
  if (m.startsWith('GET ')) return _Kind.request;
  if (m.startsWith('page ') || m.contains('← ')) return _Kind.response;
  if (m.trimLeft().startsWith('←')) return _Kind.response;
  return _Kind.info;
}

class _LogRow extends StatelessWidget {
  const _LogRow({required this.entry, required this.rel});

  final ApiLogEntry entry;
  final String rel;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final kind = _kindOf(entry);
    final (IconData icon, Color color) = switch (kind) {
      _Kind.request => (Icons.north_east, cs.primary),
      _Kind.response => (Icons.south_west, Colors.teal),
      _Kind.retry => (Icons.refresh, Colors.orange),
      _Kind.error => (Icons.error_outline, cs.error),
      _Kind.done => (Icons.check_circle, cs.primary),
      _Kind.info => (Icons.circle, cs.onSurfaceVariant),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1, right: 6),
            child: Icon(icon, size: kind == _Kind.info ? 7 : 13, color: color),
          ),
          SizedBox(
            width: 52,
            child: Text(
              rel,
              style: TextStyle(
                fontSize: 10.5,
                fontFamily: 'monospace',
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              entry.message.trim(),
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                height: 1.3,
                color: entry.error
                    ? cs.error
                    : entry.done
                    ? cs.primary
                    : cs.onSurface,
                fontWeight: entry.done ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Meter extends StatelessWidget {
  const _Meter({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: cs.onSurfaceVariant),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }
}

class _IndeterminateBar extends StatelessWidget {
  const _IndeterminateBar();

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(4),
    child: const LinearProgressIndicator(minHeight: 4),
  );
}

class _Beacon extends StatefulWidget {
  const _Beacon({required this.active, required this.color});
  final bool active;
  final Color color;
  final double size = 14;

  @override
  State<_Beacon> createState() => _BeaconState();
}

class _BeaconState extends State<_Beacon> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) {
      return Icon(Icons.cloud_done, size: widget.size + 4, color: widget.color);
    }
    return SizedBox(
      width: widget.size + 8,
      height: widget.size + 8,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: (1 - t) * 0.5,
                child: Container(
                  width: (widget.size + 8) * t,
                  height: (widget.size + 8) * t,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
