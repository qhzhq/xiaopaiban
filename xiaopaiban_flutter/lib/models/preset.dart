import 'app_settings.dart';

/// 预设配置模型
class Preset {
  final String id;
  final String name;
  final String icon;
  final String description;
  final Map<String, dynamic> settings;

  const Preset({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    this.settings = const {},
  });

  /// 从 JSON 创建
  factory Preset.fromJson(Map<String, dynamic> json) {
    return Preset(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
      settings: json['settings'] as Map<String, dynamic>? ?? {},
    );
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'settings': settings,
    };
  }

  /// 内置预设列表
  static List<Preset> get builtInPresets => [
        const Preset(
          id: 'novel',
          name: '小说投稿',
          icon: '📖',
          description: '适合小说投稿的排版格式',
          settings: {
            'indentation': 2,
            'spaces': 0,
            'lineBreaks': 1,
            'fullHalf': 1,
            'punctuation': 1,
            'wave': 1,
          },
        ),
        const Preset(
          id: 'paper',
          name: '论文排版',
          icon: '📝',
          description: '学术论文标准排版格式',
          settings: {
            'indentation': 2,
            'spaces': 1,
            'lineBreaks': 1,
            'fullHalf': 1,
            'punctuation': 1,
            'wave': 0,
          },
        ),
        const Preset(
          id: 'wechat',
          name: '公众号排版',
          icon: '💬',
          description: '微信公众号文章排版',
          settings: {
            'indentation': 0,
            'spaces': 1,
            'lineBreaks': 1,
            'fullHalf': 1,
            'punctuation': 1,
            'wave': 0,
          },
        ),
        const Preset(
          id: 'clean',
          name: '纯文本清理',
          icon: '✨',
          description: '清理多余空格和特殊字符',
          settings: {
            'indentation': 0,
            'spaces': 0,
            'lineBreaks': 1,
            'fullHalf': 1,
            'punctuation': 0,
            'wave': 0,
          },
        ),
        const Preset(
          id: 'code',
          name: '代码注释',
          icon: '💻',
          description: '代码注释格式化',
          settings: {
            'indentation': 2,
            'spaces': 0,
            'lineBreaks': 1,
            'fullHalf': 0,
            'punctuation': 0,
            'wave': 0,
          },
        ),
        const Preset(
          id: 'custom',
          name: '自定义',
          icon: '⚙️',
          description: '自定义排版设置',
        ),
      ];

  /// 将预设设置应用到当前设置
  AppSettings applyTo(AppSettings current) {
    if (settings.isEmpty) return current;
    return current.copyWith(
      indentation: settings['indentation'] as int?,
      spaces: settings['spaces'] as int?,
      lineBreaks: settings['lineBreaks'] as int?,
      fullHalf: settings['fullHalf'] as int?,
      punctuation: settings['punctuation'] as int?,
      wave: settings['wave'] as int?,
    );
  }
}
