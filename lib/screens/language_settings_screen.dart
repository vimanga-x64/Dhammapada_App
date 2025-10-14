import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  final List<Map<String, dynamic>> _languages = [
    {
      'code': 'en',
      'name': 'English',
      'nativeName': 'English',
      'flag': '🇺🇸',
      'available': true,
    },
    {
      'code': 'es',
      'name': 'Spanish',
      'nativeName': 'Español',
      'flag': '🇪🇸',
      'available': false,
    },
    {
      'code': 'fr',
      'name': 'French',
      'nativeName': 'Français',
      'flag': '🇫🇷',
      'available': false,
    },
    {
      'code': 'de',
      'name': 'German',
      'nativeName': 'Deutsch',
      'flag': '🇩🇪',
      'available': false,
    },
    {
      'code': 'hi',
      'name': 'Hindi',
      'nativeName': 'हिन्दी',
      'flag': '🇮🇳',
      'available': false,
    },
    {
      'code': 'zh',
      'name': 'Chinese',
      'nativeName': '中文',
      'flag': '🇨🇳',
      'available': false,
    },
    {
      'code': 'ja',
      'name': 'Japanese',
      'nativeName': '日本語',
      'flag': '🇯🇵',
      'available': false,
    },
  ];

  final List<Map<String, dynamic>> _translations = [
    {
      'id': 'translator_a',
      'name': 'English (Translator A)',
      'description': 'Modern English translation with contemporary language',
      'translator': 'Translator A',
      'year': '2020',
    },
    {
      'id': 'translator_b',
      'name': 'English (Translator B)',
      'description': 'Classical English translation with traditional prose',
      'translator': 'Translator B',
      'year': '1995',
    },
    {
      'id': 'pali',
      'name': 'Pali Original',
      'description': 'Original Pali text with pronunciation guide',
      'translator': 'Original',
      'year': 'Ancient',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language & Translation'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('App Language'),
                _buildAppLanguageSection(),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Verse Translation'),
                _buildTranslationSection(settings),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Text-to-Speech Language'),
                _buildTtsLanguageSection(settings),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Download Languages'),
                _buildDownloadSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildAppLanguageSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: _languages.map((language) {
          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: language['available'] 
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      language['flag'],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                title: Text(
                  language['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: language['available'] ? null : Colors.grey,
                  ),
                ),
                subtitle: Text(
                  language['nativeName'],
                  style: TextStyle(
                    color: language['available'] ? Colors.grey[600] : Colors.grey,
                  ),
                ),
                trailing: language['available']
                    ? (language['code'] == 'en'
                        ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                        : null)
                    : const Text('Coming Soon', style: TextStyle(color: Colors.grey)),
                onTap: language['available'] ? () {
                  _selectAppLanguage(language);
                } : null,
              ),
              if (_languages.last != language) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTranslationSection(SettingsProvider settings) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: _translations.map((translation) {
          final isSelected = settings.preferredTranslation == translation['name'];
          return Column(
            children: [
              RadioListTile<String>(
                value: translation['name'],
                groupValue: settings.preferredTranslation,
                onChanged: (value) {
                  settings.setPreferredTranslation(value!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Translation changed to ${translation['name']}')),
                  );
                },
                title: Text(
                  translation['name'],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(translation['description']),
                    const SizedBox(height: 4),
                    Text(
                      'By ${translation['translator']} • ${translation['year']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                activeColor: Theme.of(context).primaryColor,
              ),
              if (_translations.last != translation) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTtsLanguageSection(SettingsProvider settings) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.record_voice_over,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            title: const Text(
              'Speech Language',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('English (US)'),
            trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
            onTap: _showTtsLanguageDialog,
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.auto_fix_high,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            title: const Text(
              'Auto-detect Language',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Automatically choose speech language'),
            value: true,
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Auto-detect ${value ? 'enabled' : 'disabled'}')),
              );
            },
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.download,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            title: const Text(
              'Download Offline Languages',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Download languages for offline use'),
            trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
            onTap: _showDownloadDialog,
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.storage,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            title: const Text(
              'Manage Downloads',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Remove downloaded language packs'),
            trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
            onTap: _showManageDownloadsDialog,
          ),
        ],
      ),
    );
  }

  void _selectAppLanguage(Map<String, dynamic> language) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change App Language'),
        content: Text('Change app language to ${language['name']}? The app will restart to apply changes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Language changed to ${language['name']}')),
              );
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showTtsLanguageDialog() {
    final ttsLanguages = [
      'English (US)',
      'English (UK)',
      'English (AU)',
      'Spanish',
      'French',
      'German',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Speech Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: ttsLanguages.length,
            itemBuilder: (context, index) {
              final language = ttsLanguages[index];
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: 'English (US)',
                onChanged: (value) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Speech language changed to $value')),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Languages'),
        content: const Text('This feature allows you to download language packs for offline use. Coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showManageDownloadsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Downloads'),
        content: const Text('No downloaded language packs found.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}