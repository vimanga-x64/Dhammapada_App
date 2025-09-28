import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/verse.dart';
import '../providers/dhammapada_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/progress_provider.dart';
import '../services/tts_service.dart';

class VerseDetailScreen extends StatefulWidget {
  final Verse verse;

  const VerseDetailScreen({super.key, required this.verse});

  @override
  State<VerseDetailScreen> createState() => _VerseDetailScreenState();
}

class _VerseDetailScreenState extends State<VerseDetailScreen> {
  final _tts = TtsService.instance;
  bool _busy = false;
  late String _selectedTranslation;

  @override
  void initState() {
    super.initState();
    // Set default translation
    _selectedTranslation = widget.verse.text.keys.firstWhere(
      (k) => k.startsWith('en_'),
      orElse: () => widget.verse.text.keys.first,
    );

    // Mark verse as read when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final progressProvider =
          Provider.of<ProgressProvider>(context, listen: false);
      progressProvider.markVerseAsRead(widget.verse.id);

      // Parse chapter number from title (you might need to adjust this)
      final chapterNumber = int.tryParse(
            widget.verse.chapterTitle.split('Chapter ')[1].split(' ')[0],
          ) ??
          1;

      progressProvider.updateCurrentPosition(
        chapterNumber,
        widget.verse.verseNumber,
      );
    });
  }

  Future<void> _toggleTts(String text) async {
    if (_tts.isSpeaking) {
      await _tts.stop();
      if (mounted) setState(() {});
      return;
    }
    setState(() => _busy = true);
    await _tts.speak(text);
    if (mounted) setState(() => _busy = false);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  String _buildVerseText() {
    // TODO: replace with your verse content
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final textScalar = settings.fontSizeScalar;
    final verse = widget.verse;

    // Filter out Pali text for the dropdown
    final translationKeys =
        verse.text.keys.where((k) => k != 'pali').toList();
    final verseText = _buildVerseText();

    return Scaffold(
      appBar: AppBar(
        title: Text('${verse.chapterTitle} — ${verse.verseNumber}'),
        actions: [
          Consumer<DhammapadaProvider>(
            builder: (context, provider, child) => IconButton(
              icon: Icon(provider.isBookmarked(verse.id)
                  ? Icons.bookmark
                  : Icons.bookmark_border),
              onPressed: () => provider.toggleBookmark(verse),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final textToShare =
                  '"${verse.text[_selectedTranslation]}"\n\n— The Dhammapada, ${verse.chapterTitle}, Verse ${verse.verseNumber}';
              Share.share(textToShare);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (verse.text.containsKey('pali'))
              Text(
                verse.text['pali']!,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 18 * textScalar,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            const SizedBox(height: 24),
            if (translationKeys.length > 1)
              DropdownButton<String>(
                value: _selectedTranslation,
                isExpanded: true,
                items: translationKeys.map((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text('Translation: ${key.replaceAll('en_', '').replaceAll('_', ' ').toUpperCase()}'),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedTranslation = newValue;
                    });
                  }
                },
              ),
            const SizedBox(height: 16),
            Text(
              verse.text[_selectedTranslation] ?? 'Translation not available.',
              style: TextStyle(
                fontSize: 20 * textScalar,
                height: 1.5, // Line spacing
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _busy ? null : () => _toggleTts(verseText),
        icon: Icon(_tts.isSpeaking ? Icons.stop : Icons.volume_up),
        label: Text(_tts.isSpeaking ? 'Stop' : 'Listen'),
      ),
    );
  }
}