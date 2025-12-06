
import 'package:empire_job/features/data/storage/shared_preferences.dart';
import 'package:empire_job/routes/routes.dart';
import 'package:empire_job/shared/supabase/keys.dart';
import 'package:fetch_client/fetch_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final httpClient = kIsWeb ? FetchClient(mode: RequestMode.cors) : null;
  await Supabase.initialize(
    url: SUPABASEURL,
    anonKey: SUPABASEKEY,
    httpClient: httpClient,
  );

  
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(SharedPrefsHelper(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Empire Job',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        cardColor: Colors.white,
        dividerColor: Colors.grey,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardColor: const Color(0xFF1E1E1E),
        dividerColor: Colors.grey,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white70),
          displaySmall: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}