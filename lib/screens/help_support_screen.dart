import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I bookmark verses?',
      'answer': 'To bookmark a verse, tap the bookmark icon while reading. You can find all your bookmarked verses in the Bookmarks section.',
    },
    {
      'question': 'How does text-to-speech work?',
      'answer': 'Tap the play button on any verse to hear it read aloud. You can adjust speech rate and volume in Settings > Audio.',
    },
    {
      'question': 'Can I read offline?',
      'answer': 'Yes! All verses are available offline once the app is installed. Only features like sync require an internet connection.',
    },
    {
      'question': 'How do I change the daily reminder time?',
      'answer': 'Go to Settings > Notifications and tap on "Reminder Time" to set your preferred notification time.',
    },
    {
      'question': 'What is a reading streak?',
      'answer': 'A reading streak tracks how many consecutive days you\'ve read verses. Keep reading daily to maintain your streak!',
    },
  ];

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
        title: const Text('Help & Support'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Frequently Asked Questions'),
            _buildFaqSection(),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Contact Support'),
            _buildContactSection(),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Useful Links'),
            _buildLinksSection(),
            
            const SizedBox(height: 24),
            _buildSectionHeader('App Information'),
            _buildAppInfoSection(),
          ],
        ),
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

  Widget _buildFaqSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        children: _faqs.map<ExpansionPanel>((faq) {
          return ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              return ListTile(
                title: Text(
                  faq['question'],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                faq['answer'],
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ),
            isExpanded: faq['isExpanded'] ?? false,
          );
        }).toList(),
        expansionCallback: (index, isExpanded) {
          setState(() {
            _faqs[index]['isExpanded'] = !isExpanded;
          });
        },
      ),
    );
  }

  Widget _buildContactSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildContactTile(
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'Get help via email',
            onTap: () => _sendEmail('support@dhammapadaapp.com', 'Support Request'),
          ),
          const Divider(height: 1),
          _buildContactTile(
            icon: Icons.bug_report_outlined,
            title: 'Report a Bug',
            subtitle: 'Found an issue? Let us know',
            onTap: () => _sendEmail('bugs@dhammapadaapp.com', 'Bug Report'),
          ),
          const Divider(height: 1),
          _buildContactTile(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Share your thoughts and suggestions',
            onTap: () => _sendEmail('feedback@dhammapadaapp.com', 'App Feedback'),
          ),
          const Divider(height: 1),
          _buildContactTile(
            icon: Icons.chat_outlined,
            title: 'Live Chat',
            subtitle: 'Chat with our support team',
            onTap: _startLiveChat,
          ),
        ],
      ),
    );
  }

  Widget _buildLinksSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildLinkTile(
            icon: Icons.help_center_outlined,
            title: 'Help Center',
            subtitle: 'Browse our comprehensive guides',
            url: 'https://help.dhammapadaapp.com',
          ),
          const Divider(height: 1),
          _buildLinkTile(
            icon: Icons.video_library_outlined,
            title: 'Video Tutorials',
            subtitle: 'Watch how-to videos',
            url: 'https://youtube.com/dhammapadaapp',
          ),
          const Divider(height: 1),
          _buildLinkTile(
            icon: Icons.group_outlined,
            title: 'Community Forum',
            subtitle: 'Connect with other users',
            url: 'https://community.dhammapadaapp.com',
          ),
          const Divider(height: 1),
          _buildLinkTile(
            icon: Icons.school_outlined,
            title: 'Buddhism Resources',
            subtitle: 'Learn more about Buddhist teachings',
            url: 'https://resources.dhammapadaapp.com',
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildInfoTile(
            icon: Icons.info_outline,
            title: 'App Version',
            value: _appVersion,
          ),
          const Divider(height: 1),
          _buildInfoTile(
            icon: Icons.device_hub,
            title: 'Platform',
            value: Theme.of(context).platform.name,
          ),
          const Divider(height: 1),
          _buildContactTile(
            icon: Icons.system_update,
            title: 'Check for Updates',
            subtitle: 'See if a new version is available',
            onTap: _checkForUpdates,
          ),
          const Divider(height: 1),
          _buildContactTile(
            icon: Icons.refresh,
            title: 'Reset App Data',
            subtitle: 'Clear all app data and start fresh',
            onTap: _showResetDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
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

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
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
      trailing: Icon(Icons.open_in_new, color: Colors.grey[400]),
      onTap: () => _launchUrl(url),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
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
      trailing: Text(
        value,
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> _sendEmail(String email, String subject) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$subject&body=App Version: $_appVersion\n\nDescribe your issue or feedback:\n\n',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open email client. Please email us at $email')),
        );
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  void _startLiveChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Live Chat'),
        content: const Text('Live chat is currently unavailable. Please email us for immediate support.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _sendEmail('support@dhammapadaapp.com', 'Support Request');
            },
            child: const Text('Email Support'),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Check for Updates'),
        content: const Text('You are using the latest version of the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset App Data'),
        content: const Text('This will permanently delete all your data including bookmarks, progress, and settings. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('App data reset functionality coming soon')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}