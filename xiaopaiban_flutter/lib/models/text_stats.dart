/// 文本统计信息模型
class TextStats {
  final int characters;       // 总字符数
  final int charactersNoSpace; // 不含空格字符数
  final int words;            // 词数
  final int lines;            // 行数
  final int paragraphs;       // 段落数

  const TextStats({
    this.characters = 0,
    this.charactersNoSpace = 0,
    this.words = 0,
    this.lines = 0,
    this.paragraphs = 0,
  });

  /// 空统计
  static const TextStats empty = TextStats();

  /// 从 JSON 创建
  factory TextStats.fromJson(Map<String, dynamic> json) {
    return TextStats(
      characters: json['characters'] as int? ?? 0,
      charactersNoSpace: json['charactersNoSpace'] as int? ?? 0,
      words: json['words'] as int? ?? 0,
      lines: json['lines'] as int? ?? 0,
      paragraphs: json['paragraphs'] as int? ?? 0,
    );
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      'characters': characters,
      'charactersNoSpace': charactersNoSpace,
      'words': words,
      'lines': lines,
      'paragraphs': paragraphs,
    };
  }

  @override
  String toString() {
    return 'TextStats(characters: $characters, words: $words, lines: $lines, paragraphs: $paragraphs)';
  }
}
