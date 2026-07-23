/// 应用常量
class AppConstants {
  AppConstants._();

  // 应用信息
  static const String appName = '小排版';
  static const String appVersion = '2.0.1';
  static const String appDescription = '一款简洁好用的文本排版工具';
  static const String appAuthor = 'xiaopaiban';
  static const String appWebsite = 'https://github.com/xiaopaiban/xiaopaiban-flutter';

  // 存储键名
  static const String storageKeySettings = 'xiaopaiban_settings';
  static const String storageKeyInputText = 'xiaopaiban_input_text';
  static const String storageKeyOutputText = 'xiaopaiban_output_text';
  static const String storageKeyHistory = 'xiaopaiban_history';
  static const String storageKeyPresets = 'xiaopaiban_presets';
  static const String storageKeyWindowSize = 'xiaopaiban_window_size';
  static const String storageKeyLastPreset = 'xiaopaiban_last_preset';

  // 窗口默认值
  static const double defaultWindowWidth = 900;
  static const double defaultWindowHeight = 600;
  static const double minWindowWidth = 700;
  static const double minWindowHeight = 500;

  // 历史记录
  static const int maxHistoryCount = 50;

  // 字体大小范围
  static const double minFontSize = 12;
  static const double maxFontSize = 20;

  // 缩进范围
  static const int minIndentation = 0;
  static const int maxIndentation = 8;

  // 空行范围
  static const int minSpaces = 0;
  static const int maxSpaces = 3;

  // 换行范围
  static const int minLineBreaks = 1;
  static const int maxLineBreaks = 5;
}
