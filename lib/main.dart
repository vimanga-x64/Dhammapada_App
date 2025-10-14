import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/dhammapada_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/progress_provider.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/sign_in_screen.dart';
import 'utils/app_themes.dart';
import 'services/tts_service.dart';
import 'services/daily_verse_service.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';
import 'widgets/shimmer_widgets.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await TtsService.instance.init();
  
  // FIXED: Use instance instead of static call
  await NotificationService.instance.init();
  await NotificationService.instance.requestPermissions();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('bookmarks');
  await Hive.openBox('settings');
  await Hive.openBox('progress');
  await DailyVerseService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        FutureProvider<DhammapadaProvider?>(
          create: (_) => DhammapadaProvider.create(),
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Dhammapada',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: settings.themeMode,
            debugShowCheckedModeBanner: false,
            home: const AppInitializer(),
          );
        },
      ),
    );
  }
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    final dhammapadaProvider = Provider.of<DhammapadaProvider?>(context);

    if (dhammapadaProvider == null) {
      // Simple loading screen
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading Dhammapada...'),
            ],
          ),
        ),
      );
    }

    return ChangeNotifierProvider.value(
      value: dhammapadaProvider,
      child: const AppRouter(),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    // FORCE SIGN IN SCREEN FOR TESTING
    /* return FutureBuilder<bool>(
      future: _isFirstLaunch(),
      builder: (context, snapshot) {
        // Add debug logging
        print('AppRouter - Connection state: ${snapshot.connectionState}');
        print('AppRouter - Data: ${snapshot.data}');
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Checking app state...'),
                ],
              ),
            ),
          );
        }

        final isFirstLaunch = snapshot.data ?? true;
        print('AppRouter - Is first launch: $isFirstLaunch');

        if (isFirstLaunch) {
          print('AppRouter - Showing SignInScreen');
          return const SignInScreen(showSkip: true, isFirstLaunch: true);
        } else {
          print('AppRouter - Showing HomeScreen');
          return const HomeScreen();
        }
      },
    );
  }

  Future<bool> _isFirstLaunch() async {
    try {
      print('Checking first launch status...');
      final box = await Hive.openBox('app_state');
      final hasLaunchedBefore = box.get('has_launched_before', defaultValue: false);
      
      print('Has launched before: $hasLaunchedBefore');
      
      if (!hasLaunchedBefore) {
        print('First launch detected, setting flag');
        await box.put('has_launched_before', true);
        return true;
      }
      return false;
    } catch (e) {
      print('Error checking first launch: $e');
      return true; // Default to first launch on error
    }*/
    return const SignInScreen(showSkip: true, isFirstLaunch: true);
  }
}