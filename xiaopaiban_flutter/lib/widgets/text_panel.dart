import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/text_stats.dart';

/// 文本面板（输入/输出）
class TextPanel extends StatefulWidget {
  final String title;
  final String text;
  final String placeholder;
  final bool readOnly;
  final TextStats? stats;
  final double fontSize;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onCopy;
  final VoidCallback? onPaste;
  final VoidCallback? onClear;

  const TextPanel({
    super.key,
    required this.title,
    this.text = '',
    this.placeholder = '',
    this.readOnly = false,
    this.stats,
    this.fontSize = 14,
    this.onChanged,
    this.onCopy,
    this.onPaste,
    this.onClear,
  });

  @override
  State<TextPanel> createState() => _TextPanelState();
}

class _TextPanelState extends State<TextPanel> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(TextPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text && widget.text != _controller.text) {
      _controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 标题栏
              _buildHeader(theme, isDark),
              // 文本输入区域
              Expanded(
                child: _buildTextField(theme, isDark),
              ),
              // 统计信息
              if (widget.stats != null) _buildStatsBar(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surface.withOpacity(0.5)
            : theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          // 标题
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: widget.readOnly
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.colorScheme.onSurface.withOpacity(0.06),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: widget.readOnly
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          const Spacer(),
          // 操作按钮
          if (_isHovered || widget.text.isNotEmpty) ...[
            if (widget.onCopy != null)
              _buildActionButton(
                theme,
                icon: Icons.copy,
                tooltip: '复制',
                onPressed: widget.onCopy,
              ),
            if (widget.onPaste != null)
              _buildActionButton(
                theme,
                icon: Icons.paste,
                tooltip: '粘贴',
                onPressed: widget.onPaste,
              ),
            if (widget.onClear != null && widget.text.isNotEmpty)
              _buildActionButton(
                theme,
                icon: Icons.close,
                tooltip: '清空',
                onPressed: widget.onClear,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
    ThemeData theme, {
    required IconData icon,
    required String tooltip,
    VoidCallback? onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(ThemeData theme, bool isDark) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      readOnly: widget.readOnly,
      onChanged: widget.onChanged,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(
        fontSize: widget.fontSize,
        height: 1.8,
        color: theme.colorScheme.onSurface,
        fontFamily: 'NotoSansSC',
      ),
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.3),
          fontSize: widget.fontSize,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: false,
        contentPadding: const EdgeInsets.all(16),
      ),
      contextMenuBuilder: (context, editableTextState) {
        return _buildContextMenu(context, editableTextState, theme);
      },
    );
  }

  Widget _buildContextMenu(
    BuildContext context,
    EditableTextState editableTextState,
    ThemeData theme,
  ) {
    final items = editableTextState.contextMenuButtonItems;
    return AdaptiveTextSelectionToolbar(
      anchors: editableTextState.contextMenuAnchors,
      children: items.map((item) {
        return TextSelectionToolbarTextButton(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          onPressed: item.onPressed,
          child: Text(item.label ?? ''),
        );
      }).toList(),
    );
  }

  Widget _buildStatsBar(ThemeData theme) {
    final stats = widget.stats!;
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        border: Border(top: BorderSide(color: theme.dividerColor)),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      child: Row(
        children: [
          _buildStatItem(theme, '字数', stats.characters.toString()),
          _buildStatDivider(theme),
          _buildStatItem(theme, '不含空格', stats.charactersNoSpace.toString()),
          _buildStatDivider(theme),
          _buildStatItem(theme, '词数', stats.words.toString()),
          _buildStatDivider(theme),
          _buildStatItem(theme, '行数', stats.lines.toString()),
          _buildStatDivider(theme),
          _buildStatItem(theme, '段落', stats.paragraphs.toString()),
        ],
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 1,
        height: 12,
        color: theme.dividerColor,
      ),
    );
  }
}
