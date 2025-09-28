import 'package:flutter/material.dart';

class BuddhistTextsScreen extends StatelessWidget {
  const BuddhistTextsScreen({super.key});

  final List<Map<String, dynamic>> buddhistTexts = const [
    {
      'title': 'Dhammapada',
      'subtitle': 'Verses of the Doctrine',
      'description': 'A collection of sayings of the Buddha in verse form',
      'chapters': '26 chapters',
      'verses': '423 verses',
      'language': 'Pali/English/Sinhala',
      'color': Colors.indigo,
      'icon': Icons.book,
      'status': 'Available',
    },
    {
      'title': 'Jataka Tales',
      'subtitle': 'Birth Stories',
      'description': 'Stories of the Buddha\'s previous lives',
      'chapters': '547 stories',
      'verses': 'Various',
      'language': 'Pali/English',
      'color': Colors.orange,
      'icon': Icons.auto_stories,
      'status': 'Coming Soon',
    },
    {
      'title': 'Sutta Nipata',
      'subtitle': 'Collection of Discourses',
      'description': 'Early discourses of the Buddha',
      'chapters': '5 chapters',
      'verses': '72 suttas',
      'language': 'Pali/English',
      'color': Colors.teal,
      'icon': Icons.chat_bubble_outline,
      'status': 'Coming Soon',
    },
    {
      'title': 'Udana',
      'subtitle': 'Inspired Utterances',
      'description': 'Solemn utterances of the Buddha',
      'chapters': '8 chapters',
      'verses': '80 utterances',
      'language': 'Pali/English',
      'color': Colors.purple,
      'icon': Icons.format_quote,
      'status': 'Coming Soon',
    },
    {
      'title': 'Itivuttaka',
      'subtitle': 'Thus It Was Said',
      'description': 'Short teachings of the Buddha',
      'chapters': '4 chapters',
      'verses': '112 teachings',
      'language': 'Pali/English',
      'color': Colors.green,
      'icon': Icons.record_voice_over,
      'status': 'Coming Soon',
    },
    {
      'title': 'Theragatha',
      'subtitle': 'Verses of Elder Monks',
      'description': 'Verses by enlightened monks',
      'chapters': '21 chapters',
      'verses': '1279 verses',
      'language': 'Pali/English',
      'color': Colors.brown,
      'icon': Icons.elderly,
      'status': 'Coming Soon',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buddhist Texts'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: buddhistTexts.length,
        itemBuilder: (context, index) {
          final text = buddhistTexts[index];
          return _buildTextCard(context, text);
        },
      ),
    );
  }

  Widget _buildTextCard(BuildContext context, Map<String, dynamic> text) {
    final bool isAvailable = text['status'] == 'Available';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: isAvailable ? () {
          // Navigate to text content
        } : () {
          _showComingSoonDialog(context, text['title']);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (text['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      text['icon'] as IconData,
                      color: text['color'] as Color,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                text['title'] as String,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isAvailable
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                text['status'] as String,
                                style: TextStyle(
                                  color: isAvailable ? Colors.green : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          text['subtitle'] as String,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                text['description'] as String,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip(Icons.bookmark_outline, text['chapters'] as String),
                  const SizedBox(width: 12),
                  _buildInfoChip(Icons.format_list_numbered, text['verses'] as String),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoChip(Icons.language, text['language'] as String),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String textName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('$textName Coming Soon!'),
        content: Text(
          'We\'re working hard to bring you $textName. Stay tuned for updates!',
        ),
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