import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/verse.dart';
import '../providers/dhammapada_provider.dart';
import 'verse_detail_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Consumer<DhammapadaProvider>(
        builder: (context, provider, child) {
          final bookmarkedVerses = provider.getBookmarkedVerses();

          if (bookmarkedVerses.isEmpty) {
            return const Center(
              child: Text('You have no bookmarked verses yet.'),
            );
          }

          return ListView.builder(
            itemCount: bookmarkedVerses.length,
            itemBuilder: (context, index) {
              Verse verse = bookmarkedVerses[index];
              final snippet = verse.text['en_translator_a'] ?? verse.text.values.first;
              return ListTile(
                title: Text('${verse.chapterTitle} — Verse ${verse.verseNumber}'),
                subtitle: Text(snippet, maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VerseDetailScreen(verse: verse),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}