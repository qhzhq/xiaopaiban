import 'package:flutter/material.dart';

/// 右键上下文菜单项
class ContextMenuItem {
  final IconData icon;
  final String label;
  final String? shortcut;
  final VoidCallback? onTap;
  final bool isDivider;

  const ContextMenuItem({
    required this.icon,
    required this.label,
    this.shortcut,
    this.onTap,
    this.isDivider = false,
  });

  const ContextMenuItem.divider()
      : icon = Icons.horizontal_rule,
        label = '',
        shortcut = null,
        onTap = null,
        isDivider = true;
}

/// 自定义右键菜单
class ContextMenu extends StatelessWidget {
  final List<ContextMenuItem> items;
  final Offset position;

  const ContextMenu({
    super.key,
    required this.items,
    required this.position,
  });

  /// 显示右键菜单
  static Future<void> show(
    BuildContext context,
    Offset position,
    List<ContextMenuItem> items,
  ) async {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 点击空白区域关闭
          Positioned.fill(
            child: GestureDetector(
              onTap: () => entry.remove(),
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          // 菜单内容
          ContextMenu(
            items: items,
            position: position,
          ),
        ],
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    // 计算菜单位置，确保不超出屏幕
    double left = position.dx;
    double top = position.dy;
    const menuWidth = 200.0;
    final menuHeight = items.length * 40.0;

    if (left + menuWidth > screenSize.width) {
      left = screenSize.width - menuWidth - 8;
    }
    if (top + menuHeight > screenSize.height) {
      top = screenSize.height - menuHeight - 8;
    }

    return Positioned(
      left: left,
      top: top,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.surface,
        shadowColor: Colors.black26,
        child: Container(
          width: menuWidth,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items.map((item) {
              if (item.isDivider) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Divider(
                    height: 1,
                    color: theme.dividerColor,
                  ),
                );
              }
              return _ContextMenuItemWidget(item: item);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// 上下文菜单项组件
class _ContextMenuItemWidget extends StatefulWidget {
  final ContextMenuItem item;

  const _ContextMenuItemWidget({required this.item});

  @override
  State<_ContextMenuItemWidget> createState() => _ContextMenuItemWidgetState();
}

class _ContextMenuItemWidgetState extends State<_ContextMenuItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = widget.item.onTap == null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          color: _isHovered && !isDisabled
              ? theme.colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          child: Row(
            children: [
              Icon(
                widget.item.icon,
                size: 16,
                color: isDisabled
                    ? theme.colorScheme.onSurface.withOpacity(0.3)
                    : _isHovered
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.item.label,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDisabled
                        ? theme.colorScheme.onSurface.withOpacity(0.3)
                        : theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
              if (widget.item.shortcut != null)
                Text(
                  widget.item.shortcut!,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
