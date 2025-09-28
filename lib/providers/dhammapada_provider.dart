import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/chapter.dart';
import '../models/verse.dart';

class DhammapadaProvider extends ChangeNotifier {
  List<Verse> _allVerses = [];
  List<Chapter> chapters = [];
  List<Verse> searchResults = [];
  late Box _bookmarksBox;
  Verse? _verseOfTheDay;
  Verse? _randomVerse;

  bool get isInitialized => _initialized;
  bool _initialized = false;

  // Private constructor
  DhammapadaProvider._();

  // Public static method for creation and async initialization
  static Future<DhammapadaProvider> create() async {
    final provider = DhammapadaProvider._();
    await provider.initialize();
    return provider;
  }

  Future<void> initialize() async {
    if (_initialized) return;

    _bookmarksBox = Hive.box('bookmarks');
    await _loadDhammapada();
    _initialized = true;
    // No need for notifyListeners() here, FutureProvider handles the initial state
  }

  Future<void> _loadDhammapada() async {
    final String response =
        await rootBundle.loadString('assets/dhammapada.json');
    final data = await json.decode(response);

    List<Chapter> loadedChapters = [];
    List<Verse> allLoadedVerses = [];

    for (var chapterData in data['chapters']) {
      Chapter chapter = Chapter.fromJson(chapterData);
      loadedChapters.add(chapter);
      allLoadedVerses.addAll(chapter.verses);
    }

    chapters = loadedChapters;
    _allVerses = allLoadedVerses;
    searchResults = _allVerses;
    _setVerseOfTheDay();
  }

  void _setVerseOfTheDay() {
    if (_allVerses.isNotEmpty) {
      final random = Random();
      _verseOfTheDay = _allVerses[random.nextInt(_allVerses.length)];
      _randomVerse = _allVerses[random.nextInt(_allVerses.length)];
    }
  }

  Verse? getVerseOfTheDay() {
    return _verseOfTheDay;
  }

  Verse? getRandomVerse() {
    return _randomVerse;
  }

  void refreshRandomVerse() {
    if (_allVerses.isNotEmpty) {
      final random = Random();
      _randomVerse = _allVerses[random.nextInt(_allVerses.length)];
      notifyListeners();
    }
  }

  List<Verse> getRecentVerses() {
    // For now, return a subset of verses. You can implement actual recent tracking later
    return _allVerses.take(10).toList();
  }

  void search(String query) {
    if (query.isEmpty) {
      searchResults = _allVerses;
    } else {
      searchResults = _allVerses.where((verse) {
        final queryLower = query.toLowerCase();
        final chapterMatch =
            verse.chapterTitle.toLowerCase().contains(queryLower);
        final textMatch = verse.text.values
            .any((text) => text.toLowerCase().contains(queryLower));
        return chapterMatch || textMatch;
      }).toList();
    }
    notifyListeners();
  }

  bool isBookmarked(String verseId) {
    return _bookmarksBox.containsKey(verseId);
  }

  void toggleBookmark(Verse verse) {
    if (isBookmarked(verse.id)) {
      _bookmarksBox.delete(verse.id);
    } else {
      // Storing a simple 'true' is enough to mark it as bookmarked.
      _bookmarksBox.put(verse.id, true);
    }
    notifyListeners();
  }

  List<Verse> getBookmarkedVerses() {
    List<Verse> bookmarked = [];
    for (var verse in _allVerses) {
      if (isBookmarked(verse.id)) {
        bookmarked.add(verse);
      }
    }
    return bookmarked;
  }
}