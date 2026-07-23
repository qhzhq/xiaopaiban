import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

/// 工具栏组件
class ToolBar extends StatelessWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        children: [
          // 排版按钮（主要操作）
          _ToolBarButton(
            icon: Icons.auto_fix_high,
            label: '一键排版',
            tooltip: 'Ctrl+Enter',
            isPrimary: true,
            onPressed: appState.isTyping ? null : () => appState.typeset(),
          ),
          const SizedBox(width: 8),
          // 交换按钮
          _ToolBarButton(
            icon: Icons.swap_horiz,
            tooltip: '交换输入输出',
            onPressed: appState.outputText.isEmpty ? null : () => appState.swapText(),
          ),
          const SizedBox(width: 4),
          // 粘贴按钮
          _ToolBarButton(
            icon: Icons.paste,
            tooltip: '粘贴文本',
            onPressed: () => appState.pasteText(),
          ),
          const SizedBox(width: 4),
          // 复制按钮
          _ToolBarButton(
            icon: Icons.copy,
            tooltip: '复制结果',
            onPressed: appState.outputText.isEmpty ? null : () => appState.copyResult(),
          ),
          const SizedBox(width: 4),
          // 清空按钮
          _ToolBarButton(
            icon: Icons.delete_outline,
            tooltip: '清空文本',
            onPressed: appState.inputText.isEmpty && appState.outputText.isEmpty
                ? null
                : () => _showClearConfirm(context, appState),
          ),
          const Spacer(),
          // 分隔线
          Container(
            width: 1,
            height: 24,
            color: theme.dividerColor,
          ),
          const SizedBox(width: 8),
          // 历史记录按钮
          _ToolBarButton(
            icon: Icons.history,
            tooltip: '历史记录',
            onPressed: () => appState.setShowExport(true), // Will show history
          ),
          const SizedBox(width: 4),
          // 查找替换按钮
          _ToolBarButton(
            icon: Icons.search,
            tooltip: '查找替换 (Ctrl+F)',
            onPressed: () => appState.toggleFindReplace(inInput: true),
          ),
          const SizedBox(width: 4),
          // 导出按钮
          _ToolBarButton(
            icon: Icons.file_download_outlined,
            tooltip: '导出设置',
            onPressed: () => appState.setShowExport(true),
          ),
          const SizedBox(width: 4),
          // 导入按钮
          _ToolBarButton(
            icon: Icons.file_upload_outlined,
            tooltip: '导入设置',
            onPressed: () => appState.setShowImport(true),
          ),
          const SizedBox(width: 4),
          // 设置按钮
          _ToolBarButton(
            icon: Icons.settings_outlined,
            tooltip: '设置',
            onPressed: () => appState.setShowSettings(true),
          ),
        ],
      ),
    );
  }

  void _showClearConfirm(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认清空'),
        content: const Text('确定要清空所有文本吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              appState.clearText();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('清空'),
          ),
        ],
      ),
    );
  }
}

/// 工具栏按钮
class _ToolBarButton extends StatefulWidget {
  final IconData icon;
  final String? label;
  final String? tooltip;
  final bool isPrimary;
  final VoidCallback? onPressed;

  const _ToolBarButton({
    required this.icon,
    this.label,
    this.tooltip,
    this.isPrimary = false,
    this.onPressed,
  });

  @override
  State<_ToolBarButton> createState() => _ToolBarButtonState();
}

class _ToolBarButtonState extends State<_ToolBarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = widget.onPressed == null;

    Color bgColor;
    Color fgColor;

    if (isDisabled) {
      bgColor = Colors.transparent;
      fgColor = theme.colorScheme.onSurface.withOpacity(0.3);
    } else if (widget.isPrimary) {
      bgColor = _isHovered
          ? theme.colorScheme.primary.withOpacity(0.9)
          : theme.colorScheme.primary;
      fgColor = Colors.white;
    } else {
      bgColor = _isHovered
          ? theme.colorScheme.onSurface.withOpacity(0.08)
          : Colors.transparent;
      fgColor = theme.colorScheme.onSurface.withOpacity(0.7);
    }

    final button = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: widget.label != null
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
              : const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
            border: widget.isPrimary && !isDisabled
                ? null
                : Border.all(
                    color: _isHovered && !isDisabled
                        ? theme.colorScheme.onSurface.withOpacity(0.2)
                        : theme.dividerColor,
                    width: 1,
                  ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: fgColor),
              if (widget.label != null) ...[
                const SizedBox(width: 6),
                Text(
                  widget.label!,
                  style: TextStyle(
                    color: fgColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }
    return button;
  }
}
