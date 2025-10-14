import 'dart:math';
import 'package:hive/hive.dart';
import '../models/verse.dart';

class DailyVerseService {
  static const String _boxName = 'dailyVerse';
  static const String _lastDateKey = 'lastDate';
  static const String _verseIdKey = 'verseId';
  static const String _streakKey = 'streak';
  static const String _lastReadKey = 'lastRead';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static Verse getTodaysVerse(List<Verse> verses) {
    if (verses.isEmpty) return _createFallbackVerse();
    
    final box = Hive.box(_boxName);
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month}-${today.day}';
    final lastDate = box.get(_lastDateKey, defaultValue: '');

    if (lastDate == todayString) {
      // Return cached verse for today
      final verseId = box.get(_verseIdKey, defaultValue: '1');
      return verses.firstWhere(
        (v) => v.id == verseId,
        orElse: () => _selectRandomVerse(verses, todayString, box),
      );
    } else {
      // New day, select new verse
      return _selectRandomVerse(verses, todayString, box);
    }
  }

  static Verse _selectRandomVerse(List<Verse> verses, String dateString, Box box) {
    // Use date as seed for consistent daily verse
    final seed = dateString.hashCode;
    final random = Random(seed);
    final verse = verses[random.nextInt(verses.length)];
    
    // Cache the selection
    box.put(_lastDateKey, dateString);
    box.put(_verseIdKey, verse.id);
    
    return verse;
  }

  static Verse _createFallbackVerse() {
    return Verse(
      id: '0',
      verseNumber: 1,
      chapterTitle: 'Daily Wisdom',
      text: {
        'pali': 'Manopubbaṅgamā dhammā',
        'english': 'All mental phenomena have mind as their forerunner.',
        'explanation': 'A reminder that our thoughts shape our reality.',
      },
      storyTitle: 'The Mind\'s Influence',
    );
  }

  static Future<void> markTodaysVerseAsRead() async {
    final box = Hive.box(_boxName);
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month}-${today.day}';
    
    await box.put(_lastReadKey, todayString);
    await _updateStreak();
  }

  static bool hasReadTodaysVerse() {
    final box = Hive.box(_boxName);
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month}-${today.day}';
    final lastRead = box.get(_lastReadKey, defaultValue: '');
    
    return lastRead == todayString;
  }

  static int getCurrentStreak() {
    final box = Hive.box(_boxName);
    return box.get(_streakKey, defaultValue: 0);
  }

  static Future<void> _updateStreak() async {
    final box = Hive.box(_boxName);
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayString = '${yesterday.year}-${yesterday.month}-${yesterday.day}';
    final lastRead = box.get(_lastReadKey, defaultValue: '');
    
    if (lastRead == yesterdayString) {
      // Continuing streak
      final currentStreak = box.get(_streakKey, defaultValue: 0);
      await box.put(_streakKey, currentStreak + 1);
    } else if (lastRead != '${today.year}-${today.month}-${today.day}') {
      // Streak broken, start new
      await box.put(_streakKey, 1);
    }
  }
}