import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_controller.dart';
import '../../data/local/repository.dart';
import '../../providers.dart';

const _tabLabels = {
  'websites': 'Websites',
  'snapshots': 'Snapshots',
  'history': 'History',
};

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providers = ref.watch(providersListProvider);
    final repo = ref.watch(repositoryProvider);
    final mode = ref.watch(themeModeProvider);
    final tabOrder =
        ref.watch(tabOrderProvider).valueOrNull ?? kDefaultTabOrder;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _Header('Appearance'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('System'),
                  icon: Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.dark_mode),
                ),
              ],
              selected: {mode},
              onSelectionChanged: (s) =>
                  ref.read(themeModeProvider.notifier).set(s.first),
            ),
          ),
          const Divider(),
          const _Header('Home tabs'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text(
              'Drag to reorder',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            onReorder: (oldIndex, newIndex) {
              final next = List<String>.from(tabOrder);
              if (newIndex > oldIndex) newIndex -= 1;
              next.insert(newIndex, next.removeAt(oldIndex));
              repo.setTabOrder(next);
            },
            children: [
              for (var i = 0; i < tabOrder.length; i++)
                ListTile(
                  key: ValueKey(tabOrder[i]),
                  leading: const Icon(Icons.tab),
                  title: Text(_tabLabels[tabOrder[i]] ?? tabOrder[i]),
                  trailing: ReorderableDragStartListener(
                    index: i,
                    child: const Icon(Icons.drag_handle),
                  ),
                ),
            ],
          ),
          const Divider(),
          const _Header('Search providers'),
          providers.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
            data: (list) {
              final visible = list
                  .where((p) => p.key != 'link_guesser')
                  .toList();
              return Column(
                children: [
                  for (final p in visible)
                    SwitchListTile(
                      title: Text(p.displayName),
                      subtitle: Text(p.key),
                      value: p.enabled,
                      onChanged: (v) => repo.setProviderEnabled(p.id, v),
                    ),
                ],
              );
            },
          ),
          const Divider(),
          const _Header('Data'),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: const Text('Clear local cache'),
            subtitle: const Text('Removes cached archive availability data'),
            onTap: () async {
              await repo.clearCache();
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Cache cleared')));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_toggle_off),
            title: const Text('Clear history'),
            subtitle: const Text('Removes visited links and snapshots'),
            onTap: () async {
              await repo.clearHistory();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('History cleared')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Clear all data'),
            subtitle: const Text(
              'Removes websites, snapshots, favorites, history',
            ),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Clear all data?'),
                  content: const Text('This cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(c, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(c, true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                await repo.clearAllData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All data cleared')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
    ),
  );
}
