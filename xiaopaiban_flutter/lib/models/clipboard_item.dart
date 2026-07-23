/// 剪贴板项模型
class ClipboardItem {
  final String id;
  final String text;
  final int timestamp;
  final bool isFavorite;

  const ClipboardItem({
    required this.id,
    required this.text,
    required this.timestamp,
    this.isFavorite = false,
  });

  /// 从 JSON 创建
  factory ClipboardItem.fromJson(Map<String, dynamic> json) {
    return ClipboardItem(
      id: json['id'] as String,
      text: json['text'] as String,
      timestamp: json['timestamp'] as int,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'timestamp': timestamp,
      'isFavorite': isFavorite,
    };
  }

  /// 复制并修改
  ClipboardItem copyWith({
    String? id,
    String? text,
    int? timestamp,
    bool? isFavorite,
  }) {
    return ClipboardItem(
      id: id ?? this.id,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// 创建新的剪贴板项
  factory ClipboardItem.create(String text) {
    final now = DateTime.now();
    return ClipboardItem(
      id: '${now.millisecondsSinceEpoch}_${now.microsecond}',
      text: text,
      timestamp: now.millisecondsSinceEpoch,
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

    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  /// 获取预览文本
  String get preview {
    if (text.length <= 50) return text;
    return '${text.substring(0, 50)}...';
  }
}
