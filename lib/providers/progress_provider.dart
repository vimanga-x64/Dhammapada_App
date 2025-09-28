import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class ProgressProvider extends ChangeNotifier {
  final Box _progressBox = Hive.box('progress');
  
  // Keys for storing data
  static const String _versesReadKey = 'verses_read';
  static const String _streakKey = 'current_streak';
  static const String _lastReadDateKey = 'last_read_date';
  static const String _totalReadingTimeKey = 'total_reading_time';
  static const String _currentChapterKey = 'current_chapter';
  static const String _currentVerseKey = 'current_verse';

  // Getters for reading statistics
  int get versesRead => _progressBox.get(_versesReadKey, defaultValue: 0);
  int get currentStreak => _progressBox.get(_streakKey, defaultValue: 0);
  int get totalReadingTime => _progressBox.get(_totalReadingTimeKey, defaultValue: 0);
  String? get lastReadDate => _progressBox.get(_lastReadDateKey);
  int get currentChapter => _progressBox.get(_currentChapterKey, defaultValue: 1);
  int get currentVerse => _progressBox.get(_currentVerseKey, defaultValue: 1);

  // Calculate reading progress percentage (out of 423 total verses in Dhammapada)
  double get readingProgressPercentage => (versesRead / 423).clamp(0.0, 1.0);

  // Mark a verse as read
  Future<void> markVerseAsRead(String verseId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final lastRead = lastReadDate;
    
    // Update verses read count
    await _progressBox.put(_versesReadKey, versesRead + 1);
    
    // Update streak
    if (lastRead == null) {
      // First time reading
      await _progressBox.put(_streakKey, 1);
    } else {
      final lastReadDateTime = DateTime.parse(lastRead);
      final todayDateTime = DateTime.parse(today);
      final daysDifference = todayDateTime.difference(lastReadDateTime).inDays;
      
      if (daysDifference == 1) {
        // Consecutive day
        await _progressBox.put(_streakKey, currentStreak + 1);
      } else if (daysDifference > 1) {
        // Streak broken
        await _progressBox.put(_streakKey, 1);
      }
      // Same day = no change to streak
    }
    
    // Update last read date
    await _progressBox.put(_lastReadDateKey, today);
    
    notifyListeners();
  }

  // Update current reading position
  Future<void> updateCurrentPosition(int chapterId, int verseId) async {
    await _progressBox.put(_currentChapterKey, chapterId);
    await _progressBox.put(_currentVerseKey, verseId);
    notifyListeners();
  }

  // Add reading time (in minutes)
  Future<void> addReadingTime(int minutes) async {
    await _progressBox.put(_totalReadingTimeKey, totalReadingTime + minutes);
    notifyListeners();
  }

  // Reset all progress
  Future<void> resetProgress() async {
    await _progressBox.clear();
    notifyListeners();
  }

  // Get formatted streak text
  String get streakText {
    if (currentStreak == 0) return '0 days';
    if (currentStreak == 1) return '1 day';
    return '$currentStreak days';
  }

  // Get reading level based on verses read
  String get readingLevel {
    if (versesRead < 50) return 'Beginner';
    if (versesRead < 150) return 'Student';
    if (versesRead < 300) return 'Scholar';
    if (versesRead < 423) return 'Devotee';
    return 'Master';
  }
}