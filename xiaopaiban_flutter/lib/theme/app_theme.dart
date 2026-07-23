import 'package:flutter/material.dart';

/// 应用主题
class AppTheme {
  AppTheme._();

  // 主色调
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // 浅色主题背景色
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightText = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextTertiary = Color(0xFF94A3B8);

  // 深色主题背景色
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkText = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);

  // 状态颜色
  static const Color successColor = Color(0xFF22C55E);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);

  /// 浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: primaryLight,
        surface: lightSurface,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightText,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: lightBg,
      cardColor: lightSurface,
      dividerColor: lightBorder,
      fontFamily: 'NotoSansSC',
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: lightText, fontWeight: FontWeight.w700),
        displayMedium: TextStyle(color: lightText, fontWeight: FontWeight.w600),
        displaySmall: TextStyle(color: lightText, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(color: lightText, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: lightText, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: lightText, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: lightText, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: lightText, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: lightText, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: lightText),
        bodyMedium: TextStyle(color: lightText),
        bodySmall: TextStyle(color: lightTextSecondary),
        labelLarge: TextStyle(color: lightText, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: lightTextSecondary),
        labelSmall: TextStyle(color: lightTextTertiary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightText,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: lightBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightText,
          side: const BorderSide(color: lightBorder),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: lightTextSecondary,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: lightText.withOpacity(0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: lightSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: lightBorder),
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: lightBorder,
        thumbColor: primaryColor,
        overlayColor: Color(0x1A2563EB),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return lightTextTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor.withOpacity(0.3);
          return lightBorder;
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: lightBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// 深色主题
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryLight,
        secondary: primaryColor,
        surface: darkSurface,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkText,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: darkBg,
      cardColor: darkSurface,
      dividerColor: darkBorder,
      fontFamily: 'NotoSansSC',
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: darkText, fontWeight: FontWeight.w700),
        displayMedium: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        displaySmall: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: darkText, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: darkText, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: darkText),
        bodyMedium: TextStyle(color: darkText),
        bodySmall: TextStyle(color: darkTextSecondary),
        labelLarge: TextStyle(color: darkText, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: darkTextSecondary),
        labelSmall: TextStyle(color: darkTextTertiary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkText,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: darkBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: primaryLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkText,
          side: const BorderSide(color: darkBorder),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: darkTextSecondary,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: darkText.withOpacity(0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(color: darkBg, fontSize: 12),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: darkSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: darkBorder),
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: primaryLight,
        inactiveTrackColor: darkBorder,
        thumbColor: primaryLight,
        overlayColor: Color(0x1A3B82F6),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryLight;
          return darkTextTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryLight.withOpacity(0.3);
          return darkBorder;
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// 根据主题名称获取主题数据
  static ThemeData getTheme(String themeName, Brightness platformBrightness) {
    switch (themeName) {
      case 'dark':
        return darkTheme;
      case 'light':
        return lightTheme;
      case 'auto':
      default:
        return platformBrightness == Brightness.dark ? darkTheme : lightTheme;
    }
  }

  /// 获取当前是否为深色主题
  static bool isDark(String themeName, Brightness platformBrightness) {
    switch (themeName) {
      case 'dark':
        return true;
      case 'light':
        return false;
      case 'auto':
      default:
        return platformBrightness == Brightness.dark;
    }
  }
}
