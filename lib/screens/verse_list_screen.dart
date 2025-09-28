import 'package:flutter/material.dart';
import '../models/chapter.dart';
import '../models/verse.dart';
import 'verse_detail_screen.dart';

class VerseListScreen extends StatelessWidget {
  final Chapter chapter;
  const VerseListScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.title),
      ),
      body: ListView.builder(
        itemCount: chapter.verses.length,
        itemBuilder: (context, index) {
          Verse verse = chapter.verses[index];
          final snippet = verse.text['en_translator_a'] ?? verse.text.values.first;
          return ListTile(
            leading: Text(
              verse.verseNumber.toString(),
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary),
            ),
            title: Text(verse.storyTitle),
            subtitle: Text(snippet, maxLines: 1, overflow: TextOverflow.ellipsis),
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
      ),
    );
  }
}