import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dhammapada_provider.dart';
import 'chapter_list_screen.dart';
import 'bookmarks_screen.dart';
import 'verse_detail_screen.dart';
import 'buddhist_texts_screen.dart';
import '../models/verse.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buddhist Texts Section (Main Feature)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Buddhist Texts',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BuddhistTextsScreen()),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const BuddhistTextsGrid(),
            
            const SizedBox(height: 32),
            
            // Quick Access Section
            Text(
              'Quick Access',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const QuickAccessCards(),
            
            const SizedBox(height: 32),
            
            // Recent Activity
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const RecentActivitySection(),
          ],
        ),
      ),
    );
  }
}

class BuddhistTextsGrid extends StatelessWidget {
  const BuddhistTextsGrid({super.key});

  final List<Map<String, dynamic>> featuredTexts = const [
    {
      'title': 'Dhammapada',
      'subtitle': '26 Chapters • 423 Verses',
      'description': 'Verses of the Doctrine',
      'color': Colors.indigo,
      'icon': Icons.book,
      'status': 'available',
      'image': 'assets/images/dhammapada.png', // Add this
    },
    {
      'title': 'Jataka Tales',
      'subtitle': '547 Stories',
      'description': 'Birth Stories of Buddha',
      'color': Colors.orange,
      'icon': Icons.auto_stories,
      'status': 'coming_soon',
      'image': 'assets/images/jataka_tales.png', // Add this
    },
    {
      'title': 'Sutta Nipata',
      'subtitle': '72 Discourses',
      'description': 'Early Buddha Teachings',
      'color': Colors.teal,
      'icon': Icons.chat_bubble_outline,
      'status': 'coming_soon',
      'image': 'assets/images/sutta_nipata.png', // Add this
    },
    {
      'title': 'Udana',
      'subtitle': '80 Utterances',
      'description': 'Inspired Expressions',
      'color': Colors.purple,
      'icon': Icons.format_quote,
      'status': 'coming_soon',
      'image': 'assets/images/udana.png', // Add this
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // Change to 1 column for larger cards
        childAspectRatio: 2.5, // Wide rectangular cards
        mainAxisSpacing: 16,
      ),
      itemCount: featuredTexts.length,
      itemBuilder: (context, index) {
        final text = featuredTexts[index];
        return _buildLargeTextCard(context, text);
      },
    );
  }

  Widget _buildLargeTextCard(BuildContext context, Map<String, dynamic> text) {
  final isAvailable = text['status'] == 'available';
  
  return GestureDetector(
    onTap: () {
      if (isAvailable) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChapterListScreen()),
        );
      } else {
        _showComingSoonDialog(context, text['title']);
      }
    },
    child: Container(
      height: 150,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (text['color'] as Color).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full background image on left side
            Row(
              children: [
                // Image section - takes up left portion
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    text['image'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              (text['color'] as Color).withOpacity(0.8),
                              (text['color'] as Color),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            text['icon'] as IconData,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Right portion - will be covered by gradient
                Expanded(
                  flex: 3,
                  child: Container(color: Colors.transparent),
                ),
              ],
            ),
            
            // Gradient overlay that fades from transparent to color
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent, // Left side transparent to show image
                    Colors.transparent,
                    (text['color'] as Color).withOpacity(0.1), // Start fading
                    (text['color'] as Color).withOpacity(0.3), // More gradient
                    (text['color'] as Color).withOpacity(0.5), // Even more
                  ],
                  stops: const [0.0, 0.3, 0.5, 0.8, 1.0],
                ),
              ),
            ),
            
            // White overlay for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.8),
                    Colors.white.withOpacity(0.95),
                  ],
                  stops: const [0.0, 0.25, 0.4, 0.7, 1.0],
                ),
              ),
            ),
            
            // Content positioned over the gradient
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Left space for image (no content here)
                  const Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  
                  // Text content on the right side - FIXED OVERFLOW
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          text['title'] as String,
                          style: TextStyle(
                            fontSize: 18, // Reduced slightly
                            fontWeight: FontWeight.bold,
                            color: (text['color'] as Color).withOpacity(0.9),
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        
                        // Description
                        Text(
                          text['description'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        
                        // Subtitle
                        Text(
                          text['subtitle'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: (text['color'] as Color).withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const Spacer(), // This pushes button to bottom
                        
                        // Bottom section - COMPACT Action button
                        LayoutBuilder(
                          builder: (context, constraints) {
                            // Check available width and adjust button accordingly
                            final availableWidth = constraints.maxWidth;
                            
                            return Container(
                              width: availableWidth, // Use all available width
                              constraints: const BoxConstraints(
                                minHeight: 32, // Minimum button height
                                maxHeight: 36, // Maximum button height
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (isAvailable) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const ChapterListScreen()),
                                    );
                                  } else {
                                    _showComingSoonDialog(context, text['title']);
                                  }
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (text['color'] as Color).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: (text['color'] as Color).withOpacity(0.4),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isAvailable ? Icons.play_arrow : Icons.schedule,
                                        size: 14,
                                        color: (text['color'] as Color),
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible( // Make text flexible
                                        child: Text(
                                          isAvailable ? 'Read Now' : 'Coming Soon',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: (text['color'] as Color),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4), // Small bottom padding
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Status badge positioned on top right
            Positioned(
              top: 12,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isAvailable
                      ? Colors.green
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  isAvailable ? 'READ' : 'SOON',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String textName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.upcoming, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded( // Add Expanded here to fix overflow
              child: Text(
                '$textName Coming Soon!',
                style: const TextStyle(fontSize: 20), // Optionally reduce font size
                maxLines: 2, // Allow text to wrap to 2 lines
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Text(
          'We\'re working hard to bring you $textName with the same beautiful experience as the Dhammapada. Stay tuned for updates!',
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

class QuickAccessCards extends StatelessWidget {
  const QuickAccessCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickAccessCard(
            context,
            'My Bookmarks',
            'Saved verses',
            Icons.bookmark_rounded,
            Colors.red,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BookmarksScreen()),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Consumer<DhammapadaProvider>(
            builder: (context, provider, child) {
              return _buildQuickAccessCard(
                context,
                'Random Verse',
                'Discover wisdom',
                Icons.shuffle,
                Colors.green,
                () {
                  final randomVerse = provider.getRandomVerse();
                  if (randomVerse != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VerseDetailScreen(verse: randomVerse),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DhammapadaProvider>(
      builder: (context, provider, child) {
        final recentVerses = provider.getRecentVerses().take(3).toList();
        
        if (recentVerses.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.history, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No recent activity',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: recentVerses.map((verse) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(
                    '${verse.verseNumber}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                title: Text(
                  verse.storyTitle,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  verse.chapterTitle,
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VerseDetailScreen(verse: verse),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}