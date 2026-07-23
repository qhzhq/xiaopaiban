import 'app_settings.dart';

/// 历史记录项模型
class HistoryItem {
  final String id;
  final String text;       // 原始文本
  final String result;     // 排版结果
  final AppSettings settings; // 使用的设置
  final int timestamp;     // 时间戳
  final String preview;    // 预览文本

  const HistoryItem({
    required this.id,
    required this.text,
    required this.result,
    required this.settings,
    required this.timestamp,
    required this.preview,
  });

  /// 从 JSON 创建
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as String,
      text: json['text'] as String,
      result: json['result'] as String,
      settings: AppSettings.fromJson(json['settings'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as int,
      preview: json['preview'] as String,
    );
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'result': result,
      'settings': settings.toJson(),
      'timestamp': timestamp,
      'preview': preview,
    };
  }

  /// 创建新的历史记录项
  factory HistoryItem.create({
    required String text,
    required String result,
    required AppSettings settings,
  }) {
    final now = DateTime.now();
    return HistoryItem(
      id: '${now.millisecondsSinceEpoch}_${now.microsecond}',
      text: text,
      result: result,
      settings: settings,
      timestamp: now.millisecondsSinceEpoch,
      preview: text.length > 100 ? '${text.substring(0, 100)}...' : text,
    );
  }

  /// 格式化时间
  String get formattedTime {
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
