
import 'package:empire_job/features/data/storage/shared_preferences.dart';
import 'package:empire_job/routes/routes.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/providers/theme_providers.dart';
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
        final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Empire Job',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorConsts.primaryColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: ColorConsts.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorConsts.white,
          foregroundColor: ColorConsts.black,
          elevation: 0,
        ),
        cardColor: ColorConsts.white,
        dividerColor: ColorConsts.greyShade300,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorConsts.primaryColor,
          brightness: Brightness.dark,
        ),
         scaffoldBackgroundColor: ColorConsts.darkBackgroundScaffold,
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorConsts.darkCardColor,
          foregroundColor: ColorConsts.darkTextColor,
          elevation: 0,
        ),
           cardColor: ColorConsts.darkCardColor,
        dividerColor: ColorConsts.darkDivider,
        textTheme:  TextTheme(
        bodyMedium: const TextStyle(color: ColorConsts.black),
          bodyLarge: const TextStyle(color: ColorConsts.black),
          bodySmall: const TextStyle(color: ColorConsts.darkTextSecondary),
          displaySmall: const TextStyle(color: ColorConsts.black),
          displayMedium: const TextStyle(color: ColorConsts.black),
          displayLarge: const TextStyle(color: ColorConsts.black),
          headlineSmall: const TextStyle(color: ColorConsts.black),
          headlineMedium: const TextStyle(color: ColorConsts.black),
          headlineLarge: const TextStyle(color: ColorConsts.black),
          titleSmall: const TextStyle(color: ColorConsts.black),
          titleMedium: const TextStyle(color: ColorConsts.black),
          titleLarge: const TextStyle(color: ColorConsts.black),
          labelSmall: const TextStyle(color: ColorConsts.black),
          labelMedium: const TextStyle(color: ColorConsts.black),
          labelLarge: const TextStyle(color: ColorConsts.black),
        ),
        iconTheme: const IconThemeData(color: ColorConsts.darkTextColor),
      ),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}