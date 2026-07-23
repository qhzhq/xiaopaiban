/// 全角半角转换模式
enum FullHalfMode {
  none(0, '保持不变'),
  letterToHalf(1, '字母→半角'),
  letterToFull(2, '字母→全角'),
  digitToHalf(3, '数字→半角'),
  digitToFull(4, '数字→全角'),
  allToHalf(5, '全部→半角'),
  allToFull(6, '全部→全角');

  final int value;
  final String label;
  const FullHalfMode(this.value, this.label);

  static FullHalfMode fromValue(int value) {
    return FullHalfMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => FullHalfMode.letterToHalf,
    );
  }
}

/// 标点符号修正模式
enum PunctuationMode {
  none(0, '保持不变'),
  chineseToEn(1, '中文→英文标点'),
  enToChinese(2, '英文→中文标点'),
  removeDuplicate(3, '去除重复标点'),
  fixAll(4, '智能修正所有');

  final int value;
  final String label;
  const PunctuationMode(this.value, this.label);

  static PunctuationMode fromValue(int value) {
    return PunctuationMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PunctuationMode.chineseToEn,
    );
  }
}

/// 波浪线修正模式
enum WaveMode {
  none(0, '保持不变'),
  toFullWidth(1, '→ ～'),
  toHalfWidth(2, '→ ~'),
  toStandard(3, '→ ——'),
  fixAll(4, '统一修正');

  final int value;
  final String label;
  const WaveMode(this.value, this.label);

  static WaveMode fromValue(int value) {
    return WaveMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WaveMode.none,
    );
  }
}

/// 文本工具函数类
class TextUtils {
  TextUtils._();

  // ========== 全角半角转换 ==========

  /// 全角字母转半角
  static String letterToHalfWidth(String text) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final code = char.codeUnitAt(0);
      // 全角字母 A-Z (0xFF21-0xFF3A) → 半角 A-Z (0x41-0x5A)
      if (code >= 0xFF21 && code <= 0xFF3A) {
        buffer.writeCharCode(code - 0xFEE0);
      }
      // 全角字母 a-z (0xFF41-0xFF5A) → 半角 a-z (0x61-0x7A)
      else if (code >= 0xFF41 && code <= 0xFF5A) {
        buffer.writeCharCode(code - 0xFEE0);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// 半角字母转全角
  static String letterToFullWidth(String text) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final code = char.codeUnitAt(0);
      // 半角字母 A-Z (0x41-0x5A) → 全角 A-Z (0xFF21-0xFF3A)
      if (code >= 0x41 && code <= 0x5A) {
        buffer.writeCharCode(code + 0xFEE0);
      }
      // 半角字母 a-z (0x61-0x7A) → 全角 a-z (0xFF41-0xFF5A)
      else if (code >= 0x61 && code <= 0x7A) {
        buffer.writeCharCode(code + 0xFEE0);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// 全角数字转半角
  static String digitToHalfWidth(String text) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final code = char.codeUnitAt(0);
      // 全角数字 0-9 (0xFF10-0xFF19) → 半角 0-9 (0x30-0x39)
      if (code >= 0xFF10 && code <= 0xFF19) {
        buffer.writeCharCode(code - 0xFEE0);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// 半角数字转全角
  static String digitToFullWidth(String text) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final code = char.codeUnitAt(0);
      // 半角数字 0-9 (0x30-0x39) → 全角 0-9 (0xFF10-0xFF19)
      if (code >= 0x30 && code <= 0x39) {
        buffer.writeCharCode(code + 0xFEE0);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// 全角转半角（全部）
  static String allToHalfWidth(String text) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final code = char.codeUnitAt(0);
      // 全角空格 0x3000 → 半角空格 0x20
      if (code == 0x3000) {
        buffer.writeCharCode(0x20);
      }
      // 全角字符 0xFF01-0xFF5E → 半角 0x21-0x7E
      else if (code >= 0xFF01 && code <= 0xFF5E) {
        buffer.writeCharCode(code - 0xFEE0);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// 半角转全角（全部）
  static String allToFullWidth(String text) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final code = char.codeUnitAt(0);
      // 半角空格 0x20 → 全角空格 0x3000
      if (code == 0x20) {
        buffer.writeCharCode(0x3000);
      }
      // 半角字符 0x21-0x7E → 全角 0xFF01-0xFF5E
      else if (code >= 0x21 && code <= 0x7E) {
        buffer.writeCharCode(code + 0xFEE0);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// 全角半角转换主函数
  static String convertFullHalf(String text, int mode) {
    switch (mode) {
      case 0: return text;
      case 1: return letterToHalfWidth(text);
      case 2: return letterToFullWidth(text);
      case 3: return digitToHalfWidth(text);
      case 4: return digitToFullWidth(text);
      case 5: return allToHalfWidth(text);
      case 6: return allToFullWidth(text);
      default: return text;
    }
  }

  // ========== 标点符号修正 ==========

  /// 中文标点→英文标点
  static String chineseToEnPunctuation(String text) {
    const Map<String, String> map = {
      '，': ', ', '。': '. ', '；': '; ', '：': ': ',
      '？': '? ', '！': '! ', '"': '"', '"': '"',
      ''': "'", ''': "'", '（': ' (', '）': ') ',
      '【': ' [', '】': '] ', '《': ' <', '》': '> ',
      '、': ', ', '…': '...', '—': ' - ',
    };
    var result = text;
    map.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    // 清理多余空格
    result = result.replaceAll(RegExp(r' {2,}'), ' ');
    return result;
  }

  /// 英文标点→中文标点
  static String enToChinesePunctuation(String text) {
    var result = text;
    // 先处理特殊情况
    result = result.replaceAll('...', '…');
    // 英文标点后跟中文字符时转换
    result = result.replaceAllMapped(
      RegExp(r',(?=\s*[\u4e00-\u9fa5])'),
      (m) => '，',
    );
    result = result.replaceAllMapped(
      RegExp(r'\.(?=\s*[\u4e00-\u9fa5])'),
      (m) => '。',
    );
    result = result.replaceAllMapped(
      RegExp(r';(?=\s*[\u4e00-\u9fa5])'),
      (m) => '；',
    );
    result = result.replaceAllMapped(
      RegExp(r':(?=\s*[\u4e00-\u9fa5])'),
      (m) => '：',
    );
    result = result.replaceAllMapped(
      RegExp(r'\?(?=\s*[\u4e00-\u9fa5])'),
      (m) => '？',
    );
    result = result.replaceAllMapped(
      RegExp(r'!(?=\s*[\u4e00-\u9fa5])'),
      (m) => '！',
    );
    return result;
  }

  /// 去除重复标点
  static String removeDuplicatePunctuation(String text) {
    var result = text;
    // 重复中文标点
    result = result.replaceAll(RegExp(r'[，,]{2,}'), '，');
    result = result.replaceAll(RegExp(r'[。.]{2,}'), '。');
    result = result.replaceAll(RegExp(r'[？?]{2,}'), '？');
    result = result.replaceAll(RegExp(r'[！!]{2,}'), '！');
    result = result.replaceAll(RegExp(r'[；;]{2,}'), '；');
    result = result.replaceAll(RegExp(r'[：:]{2,}'), '：');
    return result;
  }

  /// 智能修正所有标点
  static String fixAllPunctuation(String text) {
    var result = text;
    // 1. 去除重复标点
    result = removeDuplicatePunctuation(result);
    // 2. 修正中英文标点混用
    result = result.replaceAll('。。', '。');
    result = result.replaceAll('，，', '，');
    result = result.replaceAll('！！', '！');
    result = result.replaceAll('？？', '？');
    // 3. 修正空格
    result = result.replaceAll(RegExp(r'\s+([，。！？；：])'), r'$1');
    result = result.replaceAll(RegExp(r'([，。！？；：])\s{2,}'), r'$1 ');
    return result;
  }

  /// 标点符号修正主函数
  static String fixPunctuation(String text, int mode) {
    switch (mode) {
      case 0: return text;
      case 1: return chineseToEnPunctuation(text);
      case 2: return enToChinesePunctuation(text);
      case 3: return removeDuplicatePunctuation(text);
      case 4: return fixAllPunctuation(text);
      default: return text;
    }
  }

  // ========== 波浪线修正 ==========

  /// 转全角波浪线
  static String waveToFullWidth(String text) {
    return text.replaceAll('~', '～').replaceAll('~', '～');
  }

  /// 转半角波浪线
  static String waveToHalfWidth(String text) {
    return text.replaceAll('～', '~').replaceAll('~', '~');
  }

  /// 转标准破折号
  static String waveToStandard(String text) {
    return text.replaceAll('~', '——').replaceAll('～', '——').replaceAll('~', '——');
  }

  /// 统一修正波浪线
  static String fixWaveAll(String text) {
    var result = text;
    // 统一各种波浪线为全角
    result = result.replaceAll('~', '～');
    result = result.replaceAll('~', '～');
    // 去除重复波浪线
    result = result.replaceAll(RegExp(r'[～~]{2,}'), '～');
    return result;
  }

  /// 波浪线修正主函数
  static String fixWave(String text, int mode) {
    switch (mode) {
      case 0: return text;
      case 1: return waveToFullWidth(text);
      case 2: return waveToHalfWidth(text);
      case 3: return waveToStandard(text);
      case 4: return fixWaveAll(text);
      default: return text;
    }
  }

  // ========== 段落处理 ==========

  /// 段首缩进
  static String addIndentation(String text, int spaces) {
    if (spaces <= 0) return text;
    final indent = ' ' * spaces;
    return text.split('\n').map((line) {
      if (line.trim().isEmpty) return line;
      return '$indent${line.trimLeft()}';
    }).join('\n');
  }

  /// 段间空行
  static String addSpaces(String text, int count) {
    if (count <= 0) return text;
    final separator = '\n' * (count + 1);
    return text.split('\n').where((line) => line.trim().isNotEmpty).join(separator);
  }

  /// 段内换行处理
  static String handleLineBreaks(String text, int maxBreaks) {
    if (maxBreaks <= 0) return text;
    final pattern = RegExp('\\n{${maxBreaks + 1},}');
    return text.replaceAll(pattern, '\n' * maxBreaks);
  }

  // ========== 完整排版 ==========

  /// 执行完整排版
  static String typeset(String text, {
    int indentation = 0,
    int spaces = 0,
    int lineBreaks = 1,
    int fullHalf = 0,
    int punctuation = 0,
    int wave = 0,
  }) {
    if (text.trim().isEmpty) return text;

    var result = text.trim();

    // 1. 规范化换行符
    result = result.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    // 2. 全角半角转换
    if (fullHalf > 0) {
      result = convertFullHalf(result, fullHalf);
    }

    // 3. 标点符号修正
    if (punctuation > 0) {
      result = fixPunctuation(result, punctuation);
    }

    // 4. 波浪线修正
    if (wave > 0) {
      result = fixWave(result, wave);
    }

    // 5. 段内换行处理
    if (lineBreaks > 0) {
      result = handleLineBreaks(result, lineBreaks);
    }

    // 6. 段间空行
    if (spaces > 0) {
      result = addSpaces(result, spaces);
    }

    // 7. 段首缩进
    if (indentation > 0) {
      result = addIndentation(result, indentation);
    }

    return result;
  }

  // ========== 文本统计 ==========

  /// 获取文本统计信息
  static Map<String, int> getTextStats(String text) {
    if (text.isEmpty) {
      return {
        'characters': 0,
        'charactersNoSpace': 0,
        'words': 0,
        'lines': 0,
        'paragraphs': 0,
      };
    }

    final characters = text.length;
    final charactersNoSpace = text.replaceAll(RegExp(r'\s'), '').length;
    
    // 词数统计：中文按字数，英文按空格分词
    final chineseChars = RegExp(r'[\u4e00-\u9fa5]').allMatches(text).length;
    final englishWords = RegExp(r'[a-zA-Z]+').allMatches(text).length;
    final words = chineseChars + englishWords;

    final lines = text.split('\n').length;
    final paragraphs = text.split(RegExp(r'\n\s*\n')).where((p) => p.trim().isNotEmpty).length;

    return {
      'characters': characters,
      'charactersNoSpace': charactersNoSpace,
      'words': words,
      'lines': lines,
      'paragraphs': paragraphs,
    };
  }

  // ========== 辅助函数 ==========

  /// 格式化文件大小
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
    }
    return '${(bytes / 1024 / 1024 / 1024).toStringAsFixed(1)} GB';
  }

  /// 格式化时间为相对时间
  static String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inHours < 1) return '${diff.inMinutes}分钟前';
    if (diff.inDays < 1) return '${diff.inHours}小时前';
    if (diff.inDays < 7) return '${diff.inDays}天前';

    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
