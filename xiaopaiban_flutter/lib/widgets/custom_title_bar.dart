import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// 自定义标题栏（桌面端）
class CustomTitleBar extends StatelessWidget {
  final String title;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final VoidCallback? onClose;

  const CustomTitleBar({
    super.key,
    this.title = '小排版',
    this.onMinimize,
    this.onMaximize,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 仅桌面端显示自定义标题栏
    if (!Platform.isWindows && !Platform.isMacOS && !Platform.isLinux) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onPanStart: (_) => windowManager.startDragging(),
      onDoubleTap: () => windowManager.toggleMaximize(),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            // macOS 红绿灯按钮区域留空
            if (Platform.isMacOS) const SizedBox(width: 70),
            // 标题
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
                textAlign: Platform.isMacOS ? TextAlign.center : TextAlign.left,
              ),
            ),
            // Windows/Linux 窗口控制按钮
            if (Platform.isWindows || Platform.isLinux) ...[
              _WindowButton(
                icon: Icons.minimize,
                onPressed: onMinimize ?? () => windowManager.minimize(),
                tooltip: '最小化',
              ),
              _WindowButton(
                icon: Icons.crop_square,
                onPressed: onMaximize ?? () => windowManager.toggleMaximize(),
                tooltip: '最大化',
              ),
              _WindowButton(
                icon: Icons.close,
                onPressed: onClose ?? () => windowManager.close(),
                tooltip: '关闭',
                isClose: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 窗口控制按钮
class _WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final bool isClose;

  const _WindowButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.isClose = false,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 46,
            height: 40,
            color: _isHovered
                ? (widget.isClose
                    ? Colors.red.withOpacity(0.8)
                    : theme.colorScheme.onSurface.withOpacity(0.1))
                : Colors.transparent,
            child: Icon(
              widget.icon,
              size: 16,
              color: _isHovered && widget.isClose
                  ? Colors.white
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
