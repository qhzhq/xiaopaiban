import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';
import '../models/history_item.dart';
import '../models/preset.dart';
import '../utils/constants.dart';

/// 本地存储服务
class StorageService {
  static StorageService? _instance;
  late SharedPreferences _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      _instance!._prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // ========== 设置 ==========

  /// 保存设置
  Future<bool> saveSettings(AppSettings settings) async {
    return await _prefs.setString(
      AppConstants.storageKeySettings,
      jsonEncode(settings.toJson()),
    );
  }

  /// 加载设置
  AppSettings loadSettings() {
    final json = _prefs.getString(AppConstants.storageKeySettings);
    if (json == null) return AppSettings.defaultSettings;
    try {
      return AppSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (e) {
      return AppSettings.defaultSettings;
    }
  }

  // ========== 文本 ==========

  /// 保存输入文本
  Future<bool> saveInputText(String text) async {
    return await _prefs.setString(AppConstants.storageKeyInputText, text);
  }

  /// 加载输入文本
  String loadInputText() {
    return _prefs.getString(AppConstants.storageKeyInputText) ?? '';
  }

  /// 保存输出文本
  Future<bool> saveOutputText(String text) async {
    return await _prefs.setString(AppConstants.storageKeyOutputText, text);
  }

  /// 加载输出文本
  String loadOutputText() {
    return _prefs.getString(AppConstants.storageKeyOutputText) ?? '';
  }

  // ========== 历史记录 ==========

  /// 保存历史记录
  Future<bool> saveHistory(List<HistoryItem> history) async {
    final jsonList = history.map((item) => item.toJson()).toList();
    return await _prefs.setString(
      AppConstants.storageKeyHistory,
      jsonEncode(jsonList),
    );
  }

  /// 加载历史记录
  List<HistoryItem> loadHistory() {
    final json = _prefs.getString(AppConstants.storageKeyHistory);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((item) => HistoryItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ========== 预设 ==========

  /// 保存自定义预设
  Future<bool> savePresets(List<Preset> presets) async {
    final jsonList = presets.map((preset) => preset.toJson()).toList();
    return await _prefs.setString(
      AppConstants.storageKeyPresets,
      jsonEncode(jsonList),
    );
  }

  /// 加载自定义预设
  List<Preset> loadPresets() {
    final json = _prefs.getString(AppConstants.storageKeyPresets);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((item) => Preset.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ========== 窗口大小 ==========

  /// 保存窗口大小
  Future<bool> saveWindowSize(double width, double height) async {
    return await _prefs.setString(
      AppConstants.storageKeyWindowSize,
      jsonEncode({'width': width, 'height': height}),
    );
  }

  /// 加载窗口大小
  Map<String, double>? loadWindowSize() {
    final json = _prefs.getString(AppConstants.storageKeyWindowSize);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return {
        'width': (map['width'] as num).toDouble(),
        'height': (map['height'] as num).toDouble(),
      };
    } catch (e) {
      return null;
    }
  }

  // ========== 最后使用的预设 ==========

  /// 保存最后使用的预设
  Future<bool> saveLastPreset(String presetId) async {
    return await _prefs.setString(AppConstants.storageKeyLastPreset, presetId);
  }

  /// 加载最后使用的预设
  String loadLastPreset() {
    return _prefs.getString(AppConstants.storageKeyLastPreset) ?? '';
  }

  // ========== 清除所有数据 ==========

  /// 清除所有存储数据
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
