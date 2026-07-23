import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../providers/app_state.dart';
import '../widgets/custom_title_bar.dart';
import '../widgets/tool_bar.dart';
import '../widgets/text_panel.dart';
import '../widgets/settings_panel.dart';
import '../widgets/history_dialog.dart';
import '../widgets/import_export_dialog.dart';
import '../widgets/context_menu.dart';
import '../widgets/toast.dart';
import '../widgets/about_dialog.dart';
import '../widgets/find_replace_panel.dart';
import '../utils/keyboard_shortcuts.dart';

/// 主屏幕
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WindowListener {
  final _inputController = TextEditingController();
  final _outputController = TextEditingController();
  final _inputFocusNode = FocusNode();
  final _outputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      windowManager.addListener(this);
    }
    // 监听状态变化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      _inputController.text = appState.inputText;
      _outputController.text = appState.outputText;
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    _inputFocusNode.dispose();
    _outputFocusNode.dispose();
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  void onWindowResize() async {
    final size = await windowManager.getSize();
    final storage = await _getStorage();
    storage?.saveWindowSize(size.width, size.height);
  }

  Future<dynamic> _getStorage() async {
    // This is a simplified version - in production, use proper dependency injection
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    // 监听 toast 消息
    if (appState.toastMessage.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastHelper.show(context, appState.toastMessage);
        appState.clearToast();
      });
    }

    // 监听对话框
    if (appState.showSettings) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appState.setShowSettings(false);
        showDialog(
          context: context,
          builder: (_) => const HistoryDialog(),
        );
      });
    }

    if (appState.showExport) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appState.setShowExport(false);
        showDialog(
          context: context,
          builder: (_) => const ExportDialog(),
        );
      });
    }

    if (appState.showImport) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appState.setShowImport(false);
        showDialog(
          context: context,
          builder: (_) => const ImportDialog(),
        );
      });
    }

    return Shortcuts(
      shortcuts: {
        ...KeyboardShortcuts.shortcutMap,
        // 全局快捷键
        const SingleActivator(LogicalKeyboardKey.enter, control: true):
            const TypesetIntent(),
        const SingleActivator(LogicalKeyboardKey.enter, meta: true):
            const TypesetIntent(),
        const SingleActivator(LogicalKeyboardKey.keyC, control: true, shift: true):
            const CopyResultIntent(),
        const SingleActivator(LogicalKeyboardKey.keyC, meta: true, shift: true):
            const CopyResultIntent(),
        const SingleActivator(LogicalKeyboardKey.keyS, control: true, shift: true):
            const SwapTextIntent(),
        const SingleActivator(LogicalKeyboardKey.keyS, meta: true, shift: true):
            const SwapTextIntent(),
        const SingleActivator(LogicalKeyboardKey.delete, control: true, shift: true):
            const ClearIntent(),
        const SingleActivator(LogicalKeyboardKey.delete, meta: true, shift: true):
            const ClearIntent(),
        // 查找替换快捷键
        const SingleActivator(LogicalKeyboardKey.keyF, control: true):
            const FindIntent(),
        const SingleActivator(LogicalKeyboardKey.keyF, meta: true):
            const FindIntent(),
        const SingleActivator(LogicalKeyboardKey.keyF, control: true, shift: true):
            const ReplaceIntent(),
        const SingleActivator(LogicalKeyboardKey.keyF, meta: true, shift: true):
            const ReplaceIntent(),
        // Escape 关闭查找替换面板
        const SingleActivator(LogicalKeyboardKey.escape):
            const ClosePanelIntent(),
      },
      child: Actions(
        actions: {
          TypesetIntent: CallbackAction<TypesetIntent>(
            onInvoke: (_) {
              appState.typeset();
              return null;
            },
          ),
          ClearIntent: CallbackAction<ClearIntent>(
            onInvoke: (_) {
              _showClearConfirm(context, appState);
              return null;
            },
          ),
          CopyResultIntent: CallbackAction<CopyResultIntent>(
            onInvoke: (_) {
              appState.copyResult();
              return null;
            },
          ),
          SwapTextIntent: CallbackAction<SwapTextIntent>(
            onInvoke: (_) {
              appState.swapText();
              return null;
            },
          ),
          FindIntent: CallbackAction<FindIntent>(
            onInvoke: (_) {
              appState.toggleFindReplace(inInput: true);
              return null;
            },
          ),
          ReplaceIntent: CallbackAction<ReplaceIntent>(
            onInvoke: (_) {
              appState.toggleFindReplace(inInput: true);
              return null;
            },
          ),
          ClosePanelIntent: CallbackAction<ClosePanelIntent>(
            onInvoke: (_) {
              if (appState.showFindReplace) {
                appState.toggleFindReplace();
              }
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Column(
              children: [
                // 自定义标题栏
                const CustomTitleBar(
                  title: '小排版',
                ),
                // 工具栏
                const ToolBar(),
                // 查找替换面板
                if (appState.showFindReplace) const FindReplacePanel(),
                // 主内容区域
                Expanded(
                  child: Row(
                    children: [
                      // 输入面板
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextPanel(
                            title: '输入文本',
                            text: appState.inputText,
                            placeholder: '请在此输入需要排版的文本...\n\n支持快捷键：\nCtrl+Enter 一键排版\nCtrl+Shift+C 复制结果\nCtrl+Shift+S 交换文本',
                            readOnly: false,
                            stats: appState.inputStats,
                            fontSize: appState.settings.fontSize,
                            onChanged: (text) {
                              appState.setInputText(text);
                            },
                            onPaste: () => appState.pasteText(),
                            onClear: appState.inputText.isEmpty
                                ? null
                                : () => _showClearConfirm(context, appState),
                          ),
                        ),
                      ),
                      // 分隔线
                      Container(
                        width: 1,
                        color: theme.dividerColor,
                      ),
                      // 输出面板
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextPanel(
                            title: '排版结果',
                            text: appState.outputText,
                            placeholder: '排版结果将在此显示...',
                            readOnly: true,
                            stats: appState.outputStats,
                            fontSize: appState.settings.fontSize,
                            onCopy: appState.outputText.isEmpty
                                ? null
                                : () => appState.copyResult(),
                            onClear: appState.outputText.isEmpty
                                ? null
                                : () {
                                    appState.clearText();
                                  },
                          ),
                        ),
                      ),
                      // 设置面板（可选显示）
                      if (appState.showSettings)
                        const SettingsPanel(),
                    ],
                  ),
                ),
                // 底部状态栏
                _buildStatusBar(context, theme, appState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context, ThemeData theme, AppState appState) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          // 版本信息
          Icon(Icons.text_fields, size: 12, color: theme.colorScheme.onSurface.withOpacity(0.4)),
          const SizedBox(width: 4),
          Text(
            '小排版 v2.0.1',
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          const SizedBox(width: 16),
          // 活动预设
          if (appState.activePreset.isNotEmpty) ...[
            Icon(Icons.tune, size: 12, color: theme.colorScheme.primary.withOpacity(0.6)),
            const SizedBox(width: 4),
            Text(
              '预设: ${appState.activePreset}',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 16),
          ],
          const Spacer(),
          // 快捷键提示
          _buildShortcutHint(theme, 'Ctrl+Enter', '排版'),
          const SizedBox(width: 12),
          _buildShortcutHint(theme, 'Ctrl+Shift+C', '复制'),
          const SizedBox(width: 12),
          _buildShortcutHint(theme, 'Ctrl+Shift+S', '交换'),
          const SizedBox(width: 12),
          _buildShortcutHint(theme, 'Ctrl+F', '查找'),
        ],
      ),
    );
  }

  Widget _buildShortcutHint(ThemeData theme, String key, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(0.06),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          child: Text(
            key,
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
        ),
      ],
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
