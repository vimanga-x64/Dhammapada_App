import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../services/auth_service.dart';
import '../services/tts_service.dart';
import '../services/notification_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                _buildSectionHeader('Appearance'),
                _buildAppearanceSettings(settings),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Reading'),
                _buildReadingSettings(settings),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Audio'),
                _buildAudioSettings(settings),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Notifications'),
                _buildNotificationSettings(settings),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Data & Privacy'),
                _buildDataSettings(),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Support'),
                _buildSupportSettings(),
                
                const SizedBox(height: 24),
                _buildSectionHeader('About'),
                _buildAboutSettings(),
                
                const SizedBox(height: 40),
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

  Widget _buildAppearanceSettings(SettingsProvider settings) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: _getThemeName(settings.themeMode),
            onTap: () => _showThemeDialog(settings),
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.text_fields,
            title: 'Font Size',
            subtitle: _getFontSizeName(settings.fontSize),
            onTap: () => _showFontSizeDialog(settings),
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            icon: Icons.animation,
            title: 'Animations',
            subtitle: 'Enable smooth transitions',
            value: settings.animationsEnabled,
            onChanged: settings.setAnimationsEnabled,
          ),
        ],
      ),
    );
  }

  Widget _buildReadingSettings(SettingsProvider settings) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.translate,
            title: 'Preferred Translation',
            subtitle: settings.preferredTranslation,
            onTap: () => _showTranslationDialog(settings),
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            icon: Icons.auto_awesome,
            title: 'Auto-scroll',
            subtitle: 'Automatically scroll through verses',
            value: settings.autoScrollEnabled,
            onChanged: settings.setAutoScrollEnabled,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.speed,
            title: 'Reading Speed',
            subtitle: '${settings.readingSpeed.toStringAsFixed(1)}x',
            onTap: () => _showReadingSpeedDialog(settings),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSettings(SettingsProvider settings) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.volume_up,
            title: 'Text-to-Speech',
            subtitle: 'Enable audio narration',
            value: settings.ttsEnabled,
            onChanged: settings.setTtsEnabled,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.record_voice_over,
            title: 'Voice',
            subtitle: settings.ttsVoice,
            onTap: settings.ttsEnabled ? () => _showVoiceDialog(settings) : null,
          ),
          const Divider(height: 1),
          _buildSliderTile(
            icon: Icons.speed,
            title: 'Speech Rate',
            value: settings.ttsRate,
            min: 0.5,
            max: 2.0,
            divisions: 15,
            onChanged: settings.ttsEnabled ? settings.setTtsRate : null,
          ),
          const Divider(height: 1),
          _buildSliderTile(
            icon: Icons.volume_down,
            title: 'Volume',
            value: settings.ttsVolume,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            onChanged: settings.ttsEnabled ? settings.setTtsVolume : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(SettingsProvider settings) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Daily Reminders',
            subtitle: 'Get reminded to read daily verses',
            value: settings.dailyNotificationsEnabled,
            onChanged: settings.setDailyNotificationsEnabled,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.schedule,
            title: 'Reminder Time',
            subtitle: settings.dailyReminderTime.format(context),
            onTap: settings.dailyNotificationsEnabled 
                ? () => _showTimePickerDialog(settings) 
                : null,
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            icon: Icons.local_fire_department,
            title: 'Reading Streak',
            subtitle: 'Celebrate your reading milestones',
            value: settings.streakNotificationsEnabled,
            onChanged: settings.setStreakNotificationsEnabled,
          ),
        ],
      ),
    );
  }

  Widget _buildDataSettings() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.cloud_sync,
            title: 'Sync Data',
            subtitle: 'Backup your progress and bookmarks',
            onTap: _syncData,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.download,
            title: 'Export Data',
            subtitle: 'Download your data as JSON',
            onTap: _exportData,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.delete_sweep,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            onTap: _clearCache,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.restore,
            title: 'Reset Settings',
            subtitle: 'Restore default settings',
            onTap: _resetSettings,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSettings() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help Center',
            subtitle: 'Get answers to common questions',
            onTap: _openHelpCenter,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.bug_report_outlined,
            title: 'Report a Bug',
            subtitle: 'Help us improve the app',
            onTap: _reportBug,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Share your thoughts with us',
            onTap: _sendFeedback,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.star_outline,
            title: 'Rate App',
            subtitle: 'Leave a review on the App Store',
            onTap: _rateApp,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSettings() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: _appVersion,
            onTap: null,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'Read our terms and conditions',
            onTap: _openTerms,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Learn how we protect your data',
            onTap: _openPrivacyPolicy,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.copyright_outlined,
            title: 'Licenses',
            subtitle: 'Open source licenses',
            onTap: _showLicenses,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withOpacity(0.1)
              : Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: onTap != null
          ? Icon(Icons.chevron_right, color: Colors.grey[400])
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double>? onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  // Dialog Methods
  Future<void> _showThemeDialog(SettingsProvider settings) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              value: ThemeMode.system,
              groupValue: settings.themeMode,
              onChanged: (value) {
                settings.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: settings.themeMode,
              onChanged: (value) {
                settings.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: settings.themeMode,
              onChanged: (value) {
                settings.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFontSizeDialog(SettingsProvider settings) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Font Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<double>(
              title: const Text('Small'),
              value: 0.8,
              groupValue: settings.fontSize,
              onChanged: (value) {
                settings.setFontSize(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<double>(
              title: const Text('Medium'),
              value: 1.0,
              groupValue: settings.fontSize,
              onChanged: (value) {
                settings.setFontSize(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<double>(
              title: const Text('Large'),
              value: 1.2,
              groupValue: settings.fontSize,
              onChanged: (value) {
                settings.setFontSize(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<double>(
              title: const Text('Extra Large'),
              value: 1.4,
              groupValue: settings.fontSize,
              onChanged: (value) {
                settings.setFontSize(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTranslationDialog(SettingsProvider settings) async {
    final translations = [
      'English (Translator A)',
      'English (Translator B)',
      'Pali Original',
    ];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preferred Translation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: translations.map((translation) => RadioListTile<String>(
            title: Text(translation),
            value: translation,
            groupValue: settings.preferredTranslation,
            onChanged: (value) {
              settings.setPreferredTranslation(value!);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  Future<void> _showReadingSpeedDialog(SettingsProvider settings) async {
    double tempSpeed = settings.readingSpeed;
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reading Speed'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${tempSpeed.toStringAsFixed(1)}x'),
              Slider(
                value: tempSpeed,
                min: 0.5,
                max: 3.0,
                divisions: 25,
                onChanged: (value) => setState(() => tempSpeed = value),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              settings.setReadingSpeed(tempSpeed);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showVoiceDialog(SettingsProvider settings) async {
    final voices = await TtsService.instance.getAvailableVoices();
    
    if (!mounted) return;
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Voice'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: voices.length,
            itemBuilder: (context, index) {
              final voice = voices[index];
              return RadioListTile<String>(
                title: Text(voice['name'] ?? 'Unknown'),
                subtitle: Text(voice['locale'] ?? ''),
                value: voice['name'] ?? '',
                groupValue: settings.ttsVoice,
                onChanged: (value) {
                  settings.setTtsVoice(value!);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePickerDialog(SettingsProvider settings) async {
    final time = await showTimePicker(
      context: context,
      initialTime: settings.dailyReminderTime,
    );
    
    if (time != null) {
      settings.setDailyReminderTime(time);
    }
  }

  // Action Methods
  Future<void> _syncData() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Syncing data...'),
          ],
        ),
      ),
    );

    // Simulate sync
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data synced successfully!')),
    );
  }

  Future<void> _exportData() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data export feature coming soon!')),
    );
  }

  Future<void> _clearCache() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will remove cached data to free up space. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (result == true) {
      // Simulate cache clearing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cache cleared successfully!')),
      );
    }
  }

  Future<void> _resetSettings() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('This will restore all settings to their default values. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (result == true) {
      context.read<SettingsProvider>().resetToDefaults();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings reset to defaults!')),
      );
    }
  }

  Future<void> _openHelpCenter() async {
    const url = 'https://yourapp.com/help';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _reportBug() async {
    const url = 'mailto:support@yourapp.com?subject=Bug Report';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _sendFeedback() async {
    const url = 'mailto:feedback@yourapp.com?subject=App Feedback';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _rateApp() async {
    // This would open the app store
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening App Store...')),
    );
  }

  Future<void> _openTerms() async {
    const url = 'https://yourapp.com/terms';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _openPrivacyPolicy() async {
    const url = 'https://yourapp.com/privacy';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _showLicenses() {
    showLicensePage(context: context);
  }

  // Helper Methods
  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  String _getFontSizeName(double size) {
    if (size <= 0.8) return 'Small';
    if (size <= 1.0) return 'Medium';
    if (size <= 1.2) return 'Large';
    return 'Extra Large';
  }
}