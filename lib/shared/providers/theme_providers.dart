import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  static const String _themeKey = 'theme_mode';

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);

    if (themeIndex == null) {
      state = ThemeMode.system;
    } else {
      state =
          ThemeMode.values[themeIndex.clamp(0, ThemeMode.values.length - 1)];
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    state = newTheme;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, newTheme.index);
  }

  Future<void> setTheme(ThemeMode theme) async {
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
  }
}
