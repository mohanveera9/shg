import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shg_app/l10n/app_localizations.dart';
import '../../providers/riverpod_providers.dart';
import '../../config/routes.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.notifications),
            value: settings.notificationsEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setNotifications(value);
            },
          ),
          SwitchListTile(
            title: Text(l10n.data_usage),
            value: settings.dataUsageAllowed,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setDataUsage(value);
            },
          ),
          ListTile(
            title: Text(l10n.language_selection_label),
            trailing: DropdownButton<String>(
              value: settings.language,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'te', child: Text('తెలుగు')),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setLanguage(value);
                  ref.read(languageProvider.notifier).state = value;
                }
              },
            ),
          ),
          ListTile(
            title: Text(l10n.app_version),
            trailing: const Text('1.0.0'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.languageSelection,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
