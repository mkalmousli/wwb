import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/deep_links.dart';
import 'core/theme_controller.dart';
import 'data/local/repository.dart';
import 'features/home/home_screen.dart';
import 'features/link/link_screen.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

class WayWayBackApp extends ConsumerStatefulWidget {
  const WayWayBackApp({super.key});

  @override
  ConsumerState<WayWayBackApp> createState() => _WayWayBackAppState();
}

class _WayWayBackAppState extends ConsumerState<WayWayBackApp> {
  @override
  void initState() {
    super.initState();
    DeepLinks.instance
      ..onLink = _openLink
      ..start();
  }

  void _openLink(String raw) {
    final url = normalizeUrl(raw);
    final nav = _navigatorKey.currentState;
    if (nav == null) return;
    nav.push(MaterialPageRoute(builder: (_) => LinkScreen(url: url)));
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(themeModeProvider);
    ThemeData theme(Brightness b) => ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF1565C0),
      brightness: b,
    );
    return MaterialApp(
      title: 'WayWayBack',
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: mode,
      theme: theme(Brightness.light),
      darkTheme: theme(Brightness.dark),
      home: const HomeScreen(),
    );
  }
}
