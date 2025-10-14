import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
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
                _buildSectionHeader('Daily Reminders'),
                _buildDailyRemindersSection(settings),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Reading Milestones'),
                _buildMilestonesSection(settings),
                
                const SizedBox(height: 24),
                _buildSectionHeader('App Updates'),
                _buildUpdatesSection(settings),
                
                const SizedBox(height: 24),
                _buildPermissionsSection(),
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

  Widget _buildDailyRemindersSection(SettingsProvider settings) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications_active,
            title: 'Daily Verse Reminder',
            subtitle: 'Get reminded to read your daily verse',
            value: settings.dailyNotificationsEnabled,
            onChanged: (value) async {
              await settings.setDailyNotificationsEnabled(value);
              if (value) {
                await NotificationService.scheduleDailyReminder(
                  settings.dailyReminderTime,
                );
              } else {
                await NotificationService.cancelDailyReminder();
              }
            },
          ),
          if (settings.dailyNotificationsEnabled) ...[
            const Divider(height: 1),
            _buildSettingsTile(
              icon: Icons.schedule,
              title: 'Reminder Time',
              subtitle: settings.dailyReminderTime.format(context),
              onTap: () => _showTimePickerDialog(settings),
            ),
            const Divider(height: 1),
            _buildDropdownTile(
              icon: Icons.repeat,
              title: 'Reminder Frequency',
              value: 'Daily',
              items: const ['Daily', 'Every 2 days', 'Weekly'],
              onChanged: (value) {
                // Handle frequency change
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Frequency changed to $value')),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMilestonesSection(SettingsProvider settings) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.local_fire_department,
            title: 'Reading Streaks',
            subtitle: 'Celebrate consecutive reading days',
            value: settings.streakNotificationsEnabled,
            onChanged: settings.setStreakNotificationsEnabled,
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            icon: Icons.emoji_events,
            title: 'Achievement Unlocked',
            subtitle: 'Get notified when you reach milestones',
            value: true, // This would be another setting
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Achievement notifications updated')),
              );
            },
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            icon: Icons.bookmark,
            title: 'Bookmark Reminders',
            subtitle: 'Revisit your saved verses',
            value: false, // This would be another setting
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmark reminders updated')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatesSection(SettingsProvider settings) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.system_update,
            title: 'App Updates',
            subtitle: 'Get notified about new features',
            value: true,
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Update notifications updated')),
              );
            },
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            icon: Icons.new_releases,
            title: 'New Content',
            subtitle: 'Notifications about new verses or features',
            value: true,
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Content notifications updated')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.settings,
            title: 'System Notification Settings',
            subtitle: 'Manage notifications in device settings',
            onTap: _openSystemNotificationSettings,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.notification_add, // Changed from Icons.test_rounded
            title: 'Test Notification',
            subtitle: 'Send a test notification',
            onTap: _sendTestNotification,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
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

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
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
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
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
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _showTimePickerDialog(SettingsProvider settings) async {
    final time = await showTimePicker(
      context: context,
      initialTime: settings.dailyReminderTime,
    );
    
    if (time != null) {
      await settings.setDailyReminderTime(time);
      await NotificationService.scheduleDailyReminder(time);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Daily reminder set for ${time.format(context)}'),
          ),
        );
      }
    }
  }

  void _openSystemNotificationSettings() {
    // This would open system settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening system notification settings...'),
      ),
    );
  }

  void _sendTestNotification() async {
    await NotificationService.showTestNotification();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test notification sent!')),
    );
  }
}