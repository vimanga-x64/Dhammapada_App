import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/dhammapada_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/progress_provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_themes.dart';
import 'services/tts_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await TtsService.instance.init(); // Initialize TTS
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('bookmarks');
  await Hive.openBox('settings');
  await Hive.openBox('progress');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
      // FutureProvider is still running, show a global loading screen
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Once the provider is available, wrap the rest of the app
    // with a ChangeNotifierProvider to listen for future updates (like bookmarks)
    return ChangeNotifierProvider.value(
      value: dhammapadaProvider,
      child: const HomeScreen(),
    );
  }
}