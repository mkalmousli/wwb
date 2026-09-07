import 'package:flutter/material.dart';

/// Small favicon for a page URL, with a graceful fallback icon.
class Favicon extends StatelessWidget {
  const Favicon(this.url, {super.key, this.size = 20});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final host = Uri.tryParse(url)?.host ?? '';
    final fallback = Icon(
      Icons.public,
      size: size,
      color: Theme.of(context).hintColor,
    );
    if (host.isEmpty) return fallback;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        'https://www.google.com/s2/favicons?domain=$host&sz=64',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, e, s) => fallback,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : SizedBox(width: size, height: size),
      ),
    );
  }
}
