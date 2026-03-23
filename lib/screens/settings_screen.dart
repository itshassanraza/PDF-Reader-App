import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/recent_documents_provider.dart';
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            children: [
              _buildSection(
                context: context, // Pass context here
                title: 'Appearance',
                children: [
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Enable dark theme'),
                    value: settings.darkMode,
                    onChanged: (value) async {
                      await settings.setDarkMode(value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Show Thumbnails'),
                    subtitle: const Text('Display file thumbnails in lists'),
                    value: settings.showThumbnails,
                    onChanged: (value) async {
                      await settings.setShowThumbnails(value);
                    },
                  ),
                  ListTile(
                    title: const Text('Default View Mode'),
                    subtitle: Text(settings.defaultViewMode.capitalize()),
                    trailing: DropdownButton<String>(
                      value: settings.defaultViewMode,
                      items: ['list', 'grid'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.capitalize()),
                        );
                      }).toList(),
                      onChanged: (String? newValue) async {
                        if (newValue != null) {
                          await settings.setDefaultViewMode(newValue);
                        }
                      },
                    ),
                  ),
                ],
              ),
              _buildSection(
                context: context, // Pass context here
                title: 'Behavior',
                children: [
                  SwitchListTile(
                    title: const Text('Auto-open Files'),
                    subtitle: const Text('Automatically open supported files'),
                    value: settings.autoOpen,
                    onChanged: (value) async {
                      await settings.setAutoOpen(value);
                    },
                  ),
                ],
              ),
              _buildSection(
                context: context, // Pass context here
                title: 'Data & Storage',
                children: [
                  ListTile(
                    title: const Text('Clear Recent Files'),
                    subtitle: const Text('Remove all recent file entries'),
                    trailing: ElevatedButton(
                      onPressed: () => _clearRecentFiles(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Clear'),
                    ),
                  ),
                ],
              ),
              _buildSection(
                context: context, // Pass context here
                title: 'About',
                children: [
                  ListTile(
                    title: const Text('Version'),
                    subtitle: Text(AppConstants.appVersion),
                  ),
                  ListTile(
                    title: const Text('Support'),
                    subtitle: const Text('Contact developer support'),
                    onTap: () {
                      // Implement support contact functionality
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required BuildContext context, // Add context parameter
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Future<void> _clearRecentFiles(BuildContext context) async {
    try {
      final provider = Provider.of<RecentDocumentsProvider>(
        context,
        listen: false,
      );
      await provider.clearRecentDocuments();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recent files cleared')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error clearing recent files: $e')),
        );
      }
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
