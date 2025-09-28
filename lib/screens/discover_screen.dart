import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dhammapada_provider.dart';
import '../models/verse.dart';
import 'verse_detail_screen.dart';
import 'chapter_list_screen.dart';
import 'verse_list_screen.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: VerseSearchDelegate());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Random Verse Section
            Text(
              'Explore Wisdom',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const RandomVerseCard(),
            
            const SizedBox(height: 32),
            
            // Browse by Theme
            Text(
              'Browse by Theme',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const ThemeCardsGrid(),
            
            const SizedBox(height: 32),
            
            // Popular Chapters
            Text(
              'Popular Chapters',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const PopularChaptersSection(),
          ],
        ),
      ),
    );
  }
}

class RandomVerseCard extends StatelessWidget {
  const RandomVerseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DhammapadaProvider>(
      builder: (context, provider, child) {
        final randomVerse = provider.getRandomVerse();
        if (randomVerse == null) {
          return const Card(child: Center(child: CircularProgressIndicator()));
        }
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VerseDetailScreen(verse: randomVerse)),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade300, Colors.teal.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shuffle, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Random Verse',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {
                        provider.refreshRandomVerse();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  randomVerse.text['en_translator_a'] ?? randomVerse.text.values.first,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  '— ${randomVerse.chapterTitle}, Verse ${randomVerse.verseNumber}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ThemeCardsGrid extends StatelessWidget {
  const ThemeCardsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final themes = [
      {
        'title': 'Mind & Thoughts',
        'icon': Icons.psychology,
        'color': Colors.purple,
        'chapters': [1, 3], // Chapters that contain mind-related verses
      },
      {
        'title': 'Wisdom',
        'icon': Icons.lightbulb_outline,
        'color': Colors.orange,
        'chapters': [6, 14], // Chapters about wisdom
      },
      {
        'title': 'Compassion',
        'icon': Icons.favorite_outline,
        'color': Colors.red,
        'chapters': [15, 16], // Chapters about love/compassion
      },
      {
        'title': 'Peace',
        'icon': Icons.spa_outlined,
        'color': Colors.green,
        'chapters': [15, 25], // Chapters about peace/happiness
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        return GestureDetector(
          onTap: () {
            _navigateToThemeVerses(context, theme);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (theme['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (theme['color'] as Color).withOpacity(0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  theme['icon'] as IconData,
                  color: theme['color'] as Color,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  theme['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToThemeVerses(BuildContext context, Map<String, dynamic> theme) {
    final provider = Provider.of<DhammapadaProvider>(context, listen: false);
    final chapterIds = theme['chapters'] as List<int>;
    
    // Get verses from specific chapters related to the theme
    final themeVerses = <Verse>[];
    for (final chapterId in chapterIds) {
      final chapter = provider.chapters.firstWhere((c) => c.id == chapterId);
      themeVerses.addAll(chapter.verses);
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ThemeVersesScreen(
          theme: theme['title'] as String,
          verses: themeVerses,
          color: theme['color'] as Color,
        ),
      ),
    );
  }
}

class PopularChaptersSection extends StatelessWidget {
  const PopularChaptersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DhammapadaProvider>(
      builder: (context, provider, child) {
        final popularChapters = provider.chapters.take(5).toList();
        
        return Column(
          children: popularChapters.map((chapter) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                tileColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(
                    '${chapter.id}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  chapter.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('${chapter.verses.length} verses'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VerseListScreen(chapter: chapter),
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

// Theme Verses Screen
class ThemeVersesScreen extends StatelessWidget {
  final String theme;
  final List<Verse> verses;
  final Color color;

  const ThemeVersesScreen({
    super.key,
    required this.theme,
    required this.verses,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(theme),
        backgroundColor: color.withOpacity(0.1),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: verses.length,
        itemBuilder: (context, index) {
          final verse = verses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Text(
                  '${verse.verseNumber}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              title: Text(verse.storyTitle),
              subtitle: Text(
                verse.text['en_translator_a'] ?? verse.text.values.first,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
        },
      ),
    );
  }
}

class VerseSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<DhammapadaProvider>(
      builder: (context, provider, child) {
        provider.search(query);
        return ListView.builder(
          itemCount: provider.searchResults.length,
          itemBuilder: (context, index) {
            final verse = provider.searchResults[index];
            return ListTile(
              title: Text('${verse.chapterTitle} - Verse ${verse.verseNumber}'),
              subtitle: Text(
                verse.text['en_translator_a'] ?? verse.text.values.first,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => VerseDetailScreen(verse: verse)),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}