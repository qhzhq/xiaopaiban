import 'package:flutter/material.dart';

/// Toast 通知组件
class AppToast extends StatefulWidget {
  final String message;
  final VoidCallback? onDismiss;

  const AppToast({
    super.key,
    required this.message,
    this.onDismiss,
  });

  @override
  State<AppToast> createState() => _AppToastState();
}

class _AppToastState extends State<AppToast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _offset = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();

    // 自动消失
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.reverse().then((_) {
          widget.onDismiss?.call();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SlideTransition(
      position: _offset,
      child: FadeTransition(
        opacity: _opacity,
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(8),
          color: theme.colorScheme.inverseSurface,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: theme.colorScheme.inversePrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.message,
                  style: TextStyle(
                    color: theme.colorScheme.onInverseSurface,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Toast 显示工具
class ToastHelper {
  static OverlayEntry? _currentToast;

  static void show(BuildContext context, String message) {
    // 移除当前 toast
    _currentToast?.remove();
    _currentToast = null;

    final overlay = Overlay.of(context);
    _currentToast = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        left: 0,
        right: 0,
        child: Center(
          child: AppToast(
            message: message,
            onDismiss: () {
              _currentToast?.remove();
              _currentToast = null;
            },
          ),
        ),
      ),
    );

    overlay.insert(_currentToast!);
  }

  static void dismiss() {
    _currentToast?.remove();
    _currentToast = null;
  }
}
