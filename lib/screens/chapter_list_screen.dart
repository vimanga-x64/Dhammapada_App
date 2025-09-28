import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chapter.dart';
import '../providers/dhammapada_provider.dart';
import 'verse_list_screen.dart';

class ChapterListScreen extends StatelessWidget {
  const ChapterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dhammapada Chapters'),
      ),
      body: Consumer<DhammapadaProvider>(
        builder: (context, provider, child) {
          // No need for a loading check here anymore
          return ListView.builder(
            itemCount: provider.chapters.length,
            itemBuilder: (context, index) {
              Chapter chapter = provider.chapters[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${chapter.id}'),
                  ),
                  title: Text(chapter.title),
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
            },
          );
        },
      ),
    );
  }
}