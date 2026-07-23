import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

/// 应用根组件
class XiaopaiBanApp extends StatelessWidget {
  const XiaopaiBanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return MaterialApp(
          title: '小排版',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _getThemeMode(appState.settings.theme),
          home: const HomeScreen(),
        );
      },
    );
  }

  ThemeMode _getThemeMode(String theme) {
    switch (theme) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'auto':
      default:
        return ThemeMode.system;
    }
  }
}
