/// 应用设置模型
class AppSettings {
  final int indentation;    // 段首缩进字符数 (0-8)
  final int spaces;         // 段间空行数 (0-3)
  final int lineBreaks;     // 段内换行数 (1-5)
  final int fullHalf;       // 全角半角 (0-5)
  final int punctuation;    // 标点符号修正 (0-4)
  final int wave;           // 波浪线修正 (0-4)
  final String theme;       // 主题: 'light' | 'dark' | 'auto'
  final double fontSize;    // 字体大小 (12-20)
  final bool autoTypeset;   // 自动排版
  final bool showLineNumbers; // 显示行号
  final bool wordWrap;      // 自动换行
  final bool syncScroll;    // 同步滚动
  final bool autoSave;      // 自动保存
  final String lastPreset;  // 最后使用的预设

  const AppSettings({
    this.indentation = 2,
    this.spaces = 0,
    this.lineBreaks = 1,
    this.fullHalf = 1,
    this.punctuation = 1,
    this.wave = 0,
    this.theme = 'auto',
    this.fontSize = 14,
    this.autoTypeset = true,
    this.showLineNumbers = false,
    this.wordWrap = true,
    this.syncScroll = true,
    this.autoSave = true,
    this.lastPreset = '',
  });

  /// 默认设置
  static const AppSettings defaultSettings = AppSettings();

  /// 从 JSON 创建
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      indentation: json['indentation'] as int? ?? 2,
      spaces: json['spaces'] as int? ?? 0,
      lineBreaks: json['lineBreaks'] as int? ?? 1,
      fullHalf: json['fullHalf'] as int? ?? 1,
      punctuation: json['punctuation'] as int? ?? 1,
      wave: json['wave'] as int? ?? 0,
      theme: json['theme'] as String? ?? 'auto',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14,
      autoTypeset: json['autoTypeset'] as bool? ?? true,
      showLineNumbers: json['showLineNumbers'] as bool? ?? false,
      wordWrap: json['wordWrap'] as bool? ?? true,
      syncScroll: json['syncScroll'] as bool? ?? true,
      autoSave: json['autoSave'] as bool? ?? true,
      lastPreset: json['lastPreset'] as String? ?? '',
    );
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      'indentation': indentation,
      'spaces': spaces,
      'lineBreaks': lineBreaks,
      'fullHalf': fullHalf,
      'punctuation': punctuation,
      'wave': wave,
      'theme': theme,
      'fontSize': fontSize,
      'autoTypeset': autoTypeset,
      'showLineNumbers': showLineNumbers,
      'wordWrap': wordWrap,
      'syncScroll': syncScroll,
      'autoSave': autoSave,
      'lastPreset': lastPreset,
    };
  }

  /// 复制并修改
  AppSettings copyWith({
    int? indentation,
    int? spaces,
    int? lineBreaks,
    int? fullHalf,
    int? punctuation,
    int? wave,
    String? theme,
    double? fontSize,
    bool? autoTypeset,
    bool? showLineNumbers,
    bool? wordWrap,
    bool? syncScroll,
    bool? autoSave,
    String? lastPreset,
  }) {
    return AppSettings(
      indentation: indentation ?? this.indentation,
      spaces: spaces ?? this.spaces,
      lineBreaks: lineBreaks ?? this.lineBreaks,
      fullHalf: fullHalf ?? this.fullHalf,
      punctuation: punctuation ?? this.punctuation,
      wave: wave ?? this.wave,
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      autoTypeset: autoTypeset ?? this.autoTypeset,
      showLineNumbers: showLineNumbers ?? this.showLineNumbers,
      wordWrap: wordWrap ?? this.wordWrap,
      syncScroll: syncScroll ?? this.syncScroll,
      autoSave: autoSave ?? this.autoSave,
      lastPreset: lastPreset ?? this.lastPreset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.indentation == indentation &&
        other.spaces == spaces &&
        other.lineBreaks == lineBreaks &&
        other.fullHalf == fullHalf &&
        other.punctuation == punctuation &&
        other.wave == wave &&
        other.theme == theme &&
        other.fontSize == fontSize &&
        other.autoTypeset == autoTypeset &&
        other.showLineNumbers == showLineNumbers &&
        other.wordWrap == wordWrap &&
        other.syncScroll == syncScroll &&
        other.autoSave == autoSave &&
        other.lastPreset == lastPreset;
  }

  @override
  int get hashCode => Object.hash(
        indentation, spaces, lineBreaks, fullHalf, punctuation, wave,
        theme, fontSize, autoTypeset, showLineNumbers, wordWrap,
        syncScroll, autoSave, lastPreset,
      );
}
