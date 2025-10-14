import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAppHeader(),
            const SizedBox(height: 32),
            
            _buildSectionHeader('App Information'),
            _buildAppInfoSection(),
            
            const SizedBox(height: 24),
            _buildSectionHeader('About the Dhammapada'),
            _buildDhammapadaInfoSection(),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Development Team'),
            _buildTeamSection(),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Legal'),
            _buildLegalSection(),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Connect With Us'),
            _buildSocialSection(),
            
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_stories,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Dhammapada App',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Version $_appVersion ($_buildNumber)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Wisdom in Your Pocket',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Dhammapada App brings the timeless wisdom of Buddhist teachings to your daily life. Read, listen, and reflect on verses that have guided seekers for over 2,500 years.',
              style: TextStyle(
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Features:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('📖', 'Complete Dhammapada collection'),
            _buildFeatureItem('🔊', 'Text-to-speech narration'),
            _buildFeatureItem('🔖', 'Bookmark favorite verses'),
            _buildFeatureItem('📱', 'Offline reading'),
            _buildFeatureItem('🔔', 'Daily verse reminders'),
            _buildFeatureItem('🎨', 'Beautiful, customizable interface'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDhammapadaInfoSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About the Dhammapada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The Dhammapada is a collection of sayings of the Buddha in verse form and one of the most widely read and best known Buddhist scriptures. It consists of 423 verses arranged in 26 chapters, each focusing on a particular theme such as mindfulness, wisdom, and compassion.',
              style: TextStyle(
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.format_quote,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'All that we are is the result of what we have thought.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildTeamMember(
            'Development Team',
            'App Development & Design',
            Icons.code,
          ),
          const Divider(height: 1),
          _buildTeamMember(
            'Buddhist Scholars',
            'Content Review & Authenticity',
            Icons.school,
          ),
          const Divider(height: 1),
          _buildTeamMember(
            'Translators',
            'Multiple Language Support',
            Icons.translate,
          ),
          const Divider(height: 1),
          _buildTeamMember(
            'Community',
            'Feedback & Testing',
            Icons.people,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, IconData icon) {
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
        name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(role),
    );
  }

  Widget _buildLegalSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildLegalTile(
            'Privacy Policy',
            'How we protect your data',
            Icons.privacy_tip_outlined,
            'https://dhammapadaapp.com/privacy',
          ),
          const Divider(height: 1),
          _buildLegalTile(
            'Terms of Service',
            'Terms and conditions of use',
            Icons.description_outlined,
            'https://dhammapadaapp.com/terms',
          ),
          const Divider(height: 1),
          _buildLegalTile(
            'Open Source Licenses',
            'Third-party software licenses',
            Icons.copyright_outlined,
            null,
          ),
          const Divider(height: 1),
          _buildLegalTile(
            'Attribution',
            'Credits and acknowledgments',
            Icons.credit_card,
            'https://dhammapadaapp.com/attribution',
          ),
        ],
      ),
    );
  }

  Widget _buildLegalTile(String title, String subtitle, IconData icon, String? url) {
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
      trailing: Icon(
        url != null ? Icons.open_in_new : Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: () {
        if (url != null) {
          _launchUrl(url);
        } else if (title == 'Open Source Licenses') {
          showLicensePage(context: context);
        }
      },
    );
  }

  Widget _buildSocialSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildSocialTile(
            'Website',
            'Visit our official website',
            Icons.web,
            'https://dhammapadaapp.com',
          ),
          const Divider(height: 1),
          _buildSocialTile(
            'Email',
            'Contact us directly',
            Icons.email_outlined,
            'mailto:hello@dhammapadaapp.com',
          ),
          const Divider(height: 1),
          _buildSocialTile(
            'Twitter',
            'Follow us for updates',
            Icons.alternate_email,
            'https://twitter.com/dhammapadaapp',
          ),
          const Divider(height: 1),
          _buildSocialTile(
            'GitHub',
            'View source code',
            Icons.code,
            'https://github.com/dhammapadaapp',
          ),
        ],
      ),
    );
  }

  Widget _buildSocialTile(String title, String subtitle, IconData icon, String url) {
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

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          '🙏',
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 8),
        Text(
          'Made with love and mindfulness',
          style: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '© 2024 Dhammapada App',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
      ],
    );
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
}