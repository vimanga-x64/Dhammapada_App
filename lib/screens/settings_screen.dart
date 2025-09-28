import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            children: [
              ListTile(
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: settings.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    settings.toggleTheme(value);
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Font Size',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Slider(
                      value: settings.fontSizeScalar,
                      min: 0.8,
                      max: 1.5,
                      divisions: 7,
                      label: settings.fontSizeScalar.toStringAsFixed(1),
                      onChanged: (value) {
                        settings.setFontSizeScalar(value);
                      },
                    ),
                    Center(
                      child: Text(
                        'This is how the text will look.',
                        style: TextStyle(fontSize: 16 * settings.fontSizeScalar),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}