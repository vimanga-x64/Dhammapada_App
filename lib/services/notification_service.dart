import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    // Handle notification tap - navigate to appropriate screen
    print('Notification tapped: ${notificationResponse.payload}');
  }

  // Request permissions (especially important for iOS)
  Future<bool> requestPermissions() async {
    if (!_isInitialized) await init();

    final bool? result = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return result ?? true;
  }

  // Schedule daily reminder
  static Future<void> scheduleDailyReminder(TimeOfDay time) async {
    await instance._scheduleDailyReminder(time);
  }

  Future<void> _scheduleDailyReminder(TimeOfDay time) async {
    if (!_isInitialized) await init();

    // Cancel existing daily reminder
    await _flutterLocalNotificationsPlugin.cancel(1);

    // Calculate next notification time
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daily_reminder',
      'Daily Verse Reminder',
      channelDescription: 'Daily reminder to read a verse from the Dhammapada',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      categoryIdentifier: 'daily_reminder',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      1, // notification ID
      'Daily Dhammapada Verse',
      'Take a moment to read today\'s verse and find inner peace 🧘‍♀️',
      scheduledTZDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
      payload: 'daily_verse',
    );
  }

  // Cancel daily reminder
  static Future<void> cancelDailyReminder() async {
    await instance._cancelDailyReminder();
  }

  Future<void> _cancelDailyReminder() async {
    if (!_isInitialized) await init();
    await _flutterLocalNotificationsPlugin.cancel(1);
  }

  // Show test notification
  static Future<void> showTestNotification() async {
    await instance._showTestNotification();
  }

  Future<void> _showTestNotification() async {
    if (!_isInitialized) await init();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'test_notification',
      'Test Notifications',
      channelDescription: 'Test notification channel',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test notification from Dhammapada App! 📱',
      platformChannelSpecifics,
      payload: 'test',
    );
  }

  // Show streak notification
  static Future<void> showStreakNotification(int streakDays) async {
    await instance._showStreakNotification(streakDays);
  }

  Future<void> _showStreakNotification(int streakDays) async {
    if (!_isInitialized) await init();

    String title = 'Reading Streak! 🔥';
    String body = 'Congratulations! You\'ve read verses for $streakDays consecutive days!';

    if (streakDays == 7) {
      body = 'Amazing! You\'ve completed a week of daily reading! 🎉';
    } else if (streakDays == 30) {
      body = 'Incredible! One month of daily wisdom reading! 🏆';
    } else if (streakDays == 100) {
      body = 'Outstanding! 100 days of consistent practice! 🌟';
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'streak_notification',
      'Reading Streak',
      channelDescription: 'Notifications for reading streak milestones',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      2,
      title,
      body,
      platformChannelSpecifics,
      payload: 'streak_$streakDays',
    );
  }

  // Show achievement notification
  static Future<void> showAchievementNotification(
      String achievement, String description) async {
    await instance._showAchievementNotification(achievement, description);
  }

  Future<void> _showAchievementNotification(
      String achievement, String description) async {
    if (!_isInitialized) await init();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'achievement_notification',
      'Achievements',
      channelDescription: 'Notifications for unlocked achievements',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      3,
      'Achievement Unlocked! 🏅',
      '$achievement: $description',
      platformChannelSpecifics,
      payload: 'achievement_$achievement',
    );
  }

  // Show bookmark reminder - FIXED
  static Future<void> showBookmarkReminder() async {
    await instance._showBookmarkReminder();
  }

  Future<void> _showBookmarkReminder() async {
    if (!_isInitialized) await init();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'bookmark_reminder',
      'Bookmark Reminders',
      channelDescription: 'Reminders to revisit bookmarked verses',
      importance: Importance.defaultImportance, // FIXED: Changed from Importance.default
      priority: Priority.defaultPriority,       // FIXED: Changed from Priority.default
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      4,
      'Revisit Your Bookmarks 📖',
      'Take a moment to reflect on your saved verses',
      platformChannelSpecifics,
      payload: 'bookmark_reminder',
    );
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await instance._cancelAllNotifications();
  }

  Future<void> _cancelAllNotifications() async {
    if (!_isInitialized) await init();
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Get pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await instance._getPendingNotifications();
  }

  Future<List<PendingNotificationRequest>> _getPendingNotifications() async {
    if (!_isInitialized) await init();
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    return await instance._areNotificationsEnabled();
  }

  Future<bool> _areNotificationsEnabled() async {
    if (!_isInitialized) await init();
    
    // For Android
    final androidImplementation = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      final bool? areEnabled = await androidImplementation.areNotificationsEnabled();
      return areEnabled ?? false;
    }
    
    // For iOS, assume enabled if we reach here
    return true;
  }
}