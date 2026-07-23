import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../models/app_settings.dart';
import '../models/history_item.dart';
import '../models/preset.dart';
import '../models/text_stats.dart';
import '../services/storage_service.dart';
import '../utils/text_utils.dart';

/// 应用状态管理
class AppState extends ChangeNotifier {
  final StorageService _storage;
  final _uuid = const Uuid();

  // 状态
  AppSettings _settings = AppSettings.defaultSettings;
  String _inputText = '';
  String _outputText = '';
  List<HistoryItem> _history = [];
  List<Preset> _customPresets = [];
  String _activePreset = '';
  bool _isTyping = false;
  bool _isLoading = false;
  String _toastMessage = '';
  bool _showSettings = false;
  bool _showExport = false;
  bool _showImport = false;

  // 查找替换状态
  bool _showFindReplace = false;
  String _findQuery = '';
  String _replaceText = '';
  bool _caseSensitive = false;
  bool _wholeWord = false;
  bool _useRegex = false;
  List<int> _findMatches = [];
  int _currentMatchIndex = -1;
  bool _isFindInInput = true; // true=输入面板, false=输出面板

  AppState(this._storage) {
    _loadState();
  }

  // ========== Getters ==========
  AppSettings get settings => _settings;
  String get inputText => _inputText;
  String get outputText => _outputText;
  List<HistoryItem> get history => List.unmodifiable(_history);
  List<Preset> get customPresets => List.unmodifiable(_customPresets);
  String get activePreset => _activePreset;
  bool get isTyping => _isTyping;
  bool get isLoading => _isLoading;
  String get toastMessage => _toastMessage;
  bool get showSettings => _showSettings;
  bool get showExport => _showExport;
  bool get showImport => _showImport;

  // 查找替换 getter
  bool get showFindReplace => _showFindReplace;
  String get findQuery => _findQuery;
  String get replaceText => _replaceText;
  bool get caseSensitive => _caseSensitive;
  bool get wholeWord => _wholeWord;
  bool get useRegex => _useRegex;
  List<int> get findMatches => _findMatches;
  int get currentMatchIndex => _currentMatchIndex;
  int get matchCount => _findMatches.length;
  bool get isFindInInput => _isFindInInput;
  bool get hasMatches => _findMatches.isNotEmpty;
  bool get hasCurrentMatch => _currentMatchIndex >= 0 && _currentMatchIndex < _findMatches.length;

  TextStats get inputStats {
    final stats = TextUtils.getTextStats(_inputText);
    return TextStats(
      characters: stats['characters']!,
      charactersNoSpace: stats['charactersNoSpace']!,
      words: stats['words']!,
      lines: stats['lines']!,
      paragraphs: stats['paragraphs']!,
    );
  }

  TextStats get outputStats {
    final stats = TextUtils.getTextStats(_outputText);
    return TextStats(
      characters: stats['characters']!,
      charactersNoSpace: stats['charactersNoSpace']!,
      words: stats['words']!,
      lines: stats['lines']!,
      paragraphs: stats['paragraphs']!,
    );
  }

  // ========== 初始化 ==========
  Future<void> _loadState() async {
    _isLoading = true;
    notifyListeners();

    _settings = _storage.loadSettings();
    _inputText = _storage.loadInputText();
    _outputText = _storage.loadOutputText();
    _history = _storage.loadHistory();
    _customPresets = _storage.loadPresets();
    _activePreset = _storage.loadLastPreset();

    _isLoading = false;
    notifyListeners();
  }

  // ========== 设置 ==========
  void updateSettings(AppSettings newSettings) {
    _settings = newSettings;
    _storage.saveSettings(newSettings);
    notifyListeners();
  }

  void resetSettings() {
    _settings = AppSettings.defaultSettings;
    _storage.saveSettings(_settings);
    _activePreset = '';
    _storage.saveLastPreset('');
    notifyListeners();
  }

  void applyPreset(Preset preset) {
    _activePreset = preset.id;
    _settings = preset.applyTo(_settings);
    _storage.saveSettings(_settings);
    _storage.saveLastPreset(preset.id);
    notifyListeners();
  }

  // ========== 文本操作 ==========
  void setInputText(String text) {
    _inputText = text;
    _storage.saveInputText(text);
    notifyListeners();
  }

  void typeset() {
    if (_inputText.trim().isEmpty) {
      _showToast('请先输入需要排版的文本');
      return;
    }

    _isTyping = true;
    notifyListeners();

    // 执行排版
    _outputText = TextUtils.typeset(
      _inputText,
      indentation: _settings.indentation,
      spaces: _settings.spaces,
      lineBreaks: _settings.lineBreaks,
      fullHalf: _settings.fullHalf,
      punctuation: _settings.punctuation,
      wave: _settings.wave,
    );

    // 保存输出文本
    _storage.saveOutputText(_outputText);

    // 添加到历史记录
    _addToHistory();

    _isTyping = false;
    _showToast('排版完成');
    notifyListeners();
  }

  void clearText() {
    _inputText = '';
    _outputText = '';
    _storage.saveInputText('');
    _storage.saveOutputText('');
    _showToast('文本已清空');
    notifyListeners();
  }

  void swapText() {
    if (_outputText.isEmpty) {
      _showToast('没有排版结果可交换');
      return;
    }
    final temp = _inputText;
    _inputText = _outputText;
    _outputText = temp;
    _storage.saveInputText(_inputText);
    _storage.saveOutputText(_outputText);
    _showToast('文本已交换');
    notifyListeners();
  }

  void pasteText() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data?.text != null && data!.text!.isNotEmpty) {
        _inputText = data.text!;
        _storage.saveInputText(_inputText);
        _showToast('已粘贴');
        notifyListeners();
      } else {
        _showToast('剪贴板为空');
      }
    } catch (e) {
      _showToast('粘贴失败');
    }
  }

  void copyResult() async {
    if (_outputText.isEmpty) {
      _showToast('没有排版结果可复制');
      return;
    }
    try {
      await Clipboard.setData(ClipboardData(text: _outputText));
      _showToast('已复制到剪贴板');
    } catch (e) {
      _showToast('复制失败');
    }
  }

  // ========== 历史记录 ==========
  void _addToHistory() {
    if (_inputText.trim().isEmpty || _outputText.trim().isEmpty) return;

    final item = HistoryItem.create(
      text: _inputText,
      result: _outputText,
      settings: _settings,
    );

    _history.insert(0, item);

    // 限制历史记录数量
    if (_history.length > 50) {
      _history = _history.sublist(0, 50);
    }

    _storage.saveHistory(_history);
  }

  void restoreFromHistory(HistoryItem item) {
    _inputText = item.text;
    _outputText = item.result;
    _settings = item.settings;
    _storage.saveInputText(_inputText);
    _storage.saveOutputText(_outputText);
    _storage.saveSettings(_settings);
    _showToast('已恢复历史记录');
    notifyListeners();
  }

  void deleteHistoryItem(String id) {
    _history.removeWhere((item) => item.id == id);
    _storage.saveHistory(_history);
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    _storage.saveHistory([]);
    _showToast('历史记录已清空');
    notifyListeners();
  }

  // ========== 自定义预设 ==========
  void addCustomPreset(Preset preset) {
    _customPresets.add(preset);
    _storage.savePresets(_customPresets);
    _showToast('预设已保存');
    notifyListeners();
  }

  void deleteCustomPreset(String id) {
    _customPresets.removeWhere((preset) => preset.id == id);
    _storage.savePresets(_customPresets);
    if (_activePreset == id) {
      _activePreset = '';
      _storage.saveLastPreset('');
    }
    notifyListeners();
  }

  // ========== 导入导出 ==========
  String exportSettings() {
    final data = {
      'version': '2.0.1',
      'exportTime': DateTime.now().toIso8601String(),
      'settings': _settings.toJson(),
      'presets': _customPresets.map((p) => p.toJson()).toList(),
      'history': _history.map((h) => h.toJson()).toList(),
    };
    // Simple JSON string representation
    final buffer = StringBuffer();
    buffer.writeln('{');
    buffer.writeln('  "version": "2.0.1",');
    buffer.writeln('  "exportTime": "${data['exportTime']}",');
    buffer.writeln('  "settings": ${_formatJson(_settings.toJson())},');
    buffer.writeln('  "presets": [${_customPresets.map((p) => _formatJson(p.toJson())).join(', ')}],');
    buffer.writeln('  "history": [${_history.take(10).map((h) => _formatJson(h.toJson())).join(', ')}]');
    buffer.writeln('}');
    return buffer.toString();
  }

  String _formatJson(Map<String, dynamic> map) {
    final entries = map.entries.map((e) => '"${e.key}": ${_jsonValue(e.value)}').join(', ');
    return '{$entries}';
  }

  String _jsonValue(dynamic value) {
    if (value is String) return '"$value"';
    if (value is bool) return value.toString();
    if (value is num) return value.toString();
    if (value is Map) return _formatJson(value as Map<String, dynamic>);
    return '"$value"';
  }

  bool importSettings(String jsonString) {
    try {
      // Simple JSON parsing for import
      // In production, use dart:convert jsonDecode
      _showToast('导入功能需要 JSON 解析支持');
      return false;
    } catch (e) {
      _showToast('导入失败：数据格式无效');
      return false;
    }
  }

  // ========== UI 状态 ==========
  void setShowSettings(bool show) {
    _showSettings = show;
    notifyListeners();
  }

  void setShowExport(bool show) {
    _showExport = show;
    notifyListeners();
  }

  void setShowImport(bool show) {
    _showImport = show;
    notifyListeners();
  }

  // ==================== 查找替换功能 ====================

  /// 切换查找替换面板显示
  void toggleFindReplace({bool? inInput}) {
    _showFindReplace = !_showFindReplace;
    if (_showFindReplace && inInput != null) {
      _isFindInInput = inInput;
    }
    if (!_showFindReplace) {
      _clearFindState();
    }
    notifyListeners();
  }

  /// 设置查找目标面板
  void setFindTarget(bool inInput) {
    _isFindInInput = inInput;
    if (_findQuery.isNotEmpty) {
      _performFind();
    }
    notifyListeners();
  }

  /// 更新查找关键词
  void setFindQuery(String query) {
    _findQuery = query;
    if (query.isEmpty) {
      _findMatches = [];
      _currentMatchIndex = -1;
    } else {
      _performFind();
    }
    notifyListeners();
  }

  /// 设置替换文本
  void setReplaceText(String text) {
    _replaceText = text;
    notifyListeners();
  }

  /// 切换大小写敏感
  void toggleCaseSensitive() {
    _caseSensitive = !_caseSensitive;
    if (_findQuery.isNotEmpty) _performFind();
    notifyListeners();
  }

  /// 切换全词匹配
  void toggleWholeWord() {
    _wholeWord = !_wholeWord;
    if (_findQuery.isNotEmpty) _performFind();
    notifyListeners();
  }

  /// 切换正则表达式
  void toggleUseRegex() {
    _useRegex = !_useRegex;
    if (_findQuery.isNotEmpty) _performFind();
    notifyListeners();
  }

  /// 执行查找
  void _performFind() {
    final text = _isFindInInput ? _inputText : _outputText;
    if (_findQuery.isEmpty || text.isEmpty) {
      _findMatches = [];
      _currentMatchIndex = -1;
      return;
    }

    try {
      Pattern pattern;
      if (_useRegex) {
        pattern = RegExp(
          _findQuery,
          caseSensitive: _caseSensitive,
        );
      } else {
        String escaped = RegExp.escape(_findQuery);
        if (_wholeWord) {
          escaped = r'\b' + escaped + r'\b';
        }
        pattern = RegExp(
          escaped,
          caseSensitive: _caseSensitive,
        );
      }

      _findMatches = [];
      for (final match in pattern.allMatches(text)) {
        _findMatches.add(match.start);
      }

      if (_findMatches.isNotEmpty) {
        _currentMatchIndex = 0;
      } else {
        _currentMatchIndex = -1;
      }
    } catch (e) {
      // 正则表达式无效
      _findMatches = [];
      _currentMatchIndex = -1;
    }
  }

  /// 跳转到下一个匹配项
  void findNext() {
    if (_findMatches.isEmpty) return;
    _currentMatchIndex = (_currentMatchIndex + 1) % _findMatches.length;
    notifyListeners();
  }

  /// 跳转到上一个匹配项
  void findPrevious() {
    if (_findMatches.isEmpty) return;
    _currentMatchIndex = (_currentMatchIndex - 1 + _findMatches.length) % _findMatches.length;
    notifyListeners();
  }

  /// 替换当前匹配项
  void replaceCurrent() {
    if (!hasCurrentMatch || _findQuery.isEmpty) return;

    final text = _isFindInInput ? _inputText : _outputText;
    final startPos = _findMatches[_currentMatchIndex];

    // 重新计算当前匹配的长度
    Pattern pattern;
    if (_useRegex) {
      pattern = RegExp(_findQuery, caseSensitive: _caseSensitive);
    } else {
      String escaped = RegExp.escape(_findQuery);
      if (_wholeWord) escaped = r'\b' + escaped + r'\b';
      pattern = RegExp(escaped, caseSensitive: _caseSensitive);
    }

    final match = pattern.matchAsPrefix(text, startPos);
    if (match == null) return;

    final before = text.substring(0, match.start);
    final after = text.substring(match.end);
    final newText = before + _replaceText + after;

    if (_isFindInInput) {
      _inputText = newText;
    } else {
      _outputText = newText;
    }

    // 重新查找
    _performFind();
    notifyListeners();
  }

  /// 替换所有匹配项
  void replaceAll() {
    if (_findQuery.isEmpty) return;

    final text = _isFindInInput ? _inputText : _outputText;

    Pattern pattern;
    if (_useRegex) {
      pattern = RegExp(_findQuery, caseSensitive: _caseSensitive);
    } else {
      String escaped = RegExp.escape(_findQuery);
      if (_wholeWord) escaped = r'\b' + escaped + r'\b';
      pattern = RegExp(escaped, caseSensitive: _caseSensitive);
    }

    final count = pattern.allMatches(text).length;
    if (count == 0) return;

    String newText;
    if (_useRegex) {
      newText = text.replaceAll(RegExp(_findQuery, caseSensitive: _caseSensitive), _replaceText);
    } else {
      String escaped = RegExp.escape(_findQuery);
      if (_wholeWord) escaped = r'\b' + escaped + r'\b';
      newText = text.replaceAll(RegExp(escaped, caseSensitive: _caseSensitive), _replaceText);
    }

    if (_isFindInInput) {
      _inputText = newText;
    } else {
      _outputText = newText;
    }

    _showToast('已替换 $count 处');
    _performFind();
    notifyListeners();
  }

  /// 清除查找状态
  void _clearFindState() {
    _findQuery = '';
    _replaceText = '';
    _findMatches = [];
    _currentMatchIndex = -1;
  }

  void _showToast(String message) {
    _toastMessage = message;
    notifyListeners();
    // Auto clear after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (_toastMessage == message) {
        _toastMessage = '';
        notifyListeners();
      }
    });
  }

  void clearToast() {
    _toastMessage = '';
    notifyListeners();
  }
}
