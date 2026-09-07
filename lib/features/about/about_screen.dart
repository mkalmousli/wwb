import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_info.dart';
import '../../core/external.dart';
import '../../core/platform.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _repo = 'https://github.com/mkalmousli/wwb';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: SvgPicture.asset('assets/wwb.svg', width: 72, height: 72),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'WayWayBack',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Center(
            child: Text(
              'Version $kAppVersion  ·  ${AppPlatform.current}',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'A simple, cross-platform client for the Internet Archive '
            'Wayback Machine. Browse a site\'s archived snapshots by '
            'year, month and day, and open them in your browser.',
          ),
          const SizedBox(height: 16),

          // Cross-platform nudge.
          Card(
            color: cs.surfaceContainerHighest,
            child: ListTile(
              leading: Icon(
                AppPlatform.isMobile ? Icons.desktop_windows : Icons.smartphone,
                color: cs.primary,
              ),
              title: Text(
                AppPlatform.isMobile
                    ? 'Use WayWayBack on desktop too'
                    : 'Use WayWayBack on your phone too',
              ),
              subtitle: Text(AppPlatform.crossPromo),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => openExternal(context, AppPlatform.releasesUrl),
            ),
          ),

          const Divider(height: 32),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: SvgPicture.asset('assets/logo.svg', width: 28, height: 28),
            title: const Text('Created by mkalmousli'),
            subtitle: const Text('al-mo.de'),
            onTap: () => openExternal(context, 'https://al-mo.de'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.favorite, color: Color(0xFFEB5E9C)),
            title: const Text('Support the project'),
            subtitle: const Text('ko-fi.com/mkalmousli'),
            onTap: () => openExternal(context, 'https://ko-fi.com/mkalmousli'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.code),
            title: const Text('Source code'),
            subtitle: const Text('github.com/mkalmousli/wwb'),
            onTap: () => openExternal(context, _repo),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('Report an issue'),
            subtitle: const Text('github.com/mkalmousli/wwb/issues'),
            onTap: () => openExternal(context, '$_repo/issues'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.balance),
            title: const Text('Licence: GNU GPL v3.0 or later'),
            subtitle: const Text('Free software, no warranty'),
            onTap: () => openExternal(
              context,
              'https://www.gnu.org/licenses/gpl-3.0.html',
            ),
          ),
          const Divider(height: 32),
          Text('Legal', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          Text(
            'WayWayBack is an independent, unofficial client. It is not the '
            'Wayback Machine and is not affiliated with, endorsed by, or '
            'connected to the Internet Archive.\n\n'
            'The app is entirely client-side: it has no backend or server of '
            'its own and stores all data locally on your device. It talks '
            'directly to the public Internet Archive endpoints '
            '(web.archive.org). All archived content, trademarks and service '
            'marks belong to their respective owners.',
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
