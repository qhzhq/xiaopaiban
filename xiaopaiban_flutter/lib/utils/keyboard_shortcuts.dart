import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 键盘快捷键定义
class KeyboardShortcuts {
  KeyboardShortcuts._();

  // 排版: Ctrl/Cmd + Enter
  static const typeset = SingleActivator(LogicalKeyboardKey.enter, control: true, meta: true);

  // 清空: Ctrl/Cmd + Shift + Delete
  static const clear = SingleActivator(LogicalKeyboardKey.delete, control: true, meta: true, shift: true);

  // 复制结果: Ctrl/Cmd + Shift + C
  static const copyResult = SingleActivator(LogicalKeyboardKey.keyC, control: true, meta: true, shift: true);

  // 交换文本: Ctrl/Cmd + Shift + S
  static const swapText = SingleActivator(LogicalKeyboardKey.keyS, control: true, meta: true, shift: true);

  // 粘贴: Ctrl/Cmd + V
  static const paste = SingleActivator(LogicalKeyboardKey.keyV, control: true, meta: true);

  // 撤销: Ctrl/Cmd + Z
  static const undo = SingleActivator(LogicalKeyboardKey.keyZ, control: true, meta: true);

  // 重做: Ctrl/Cmd + Shift + Z
  static const redo = SingleActivator(LogicalKeyboardKey.keyZ, control: true, meta: true, shift: true);

  // 设置: Ctrl/Cmd + ,
  static const settings = SingleActivator(LogicalKeyboardKey.comma, control: true, meta: true);

  // 历史记录: Ctrl/Cmd + H
  static const history = SingleActivator(LogicalKeyboardKey.keyH, control: true, meta: true);

  // 导出: Ctrl/Cmd + E
  static const export = SingleActivator(LogicalKeyboardKey.keyE, control: true, meta: true);

  // 导入: Ctrl/Cmd + I
  static const import_ = SingleActivator(LogicalKeyboardKey.keyI, control: true, meta: true);

  // 退出: Ctrl/Cmd + Q
  static const quit = SingleActivator(LogicalKeyboardKey.keyQ, control: true, meta: true);

  // 查找: Ctrl/Cmd + F
  static const find = SingleActivator(LogicalKeyboardKey.keyF, control: true, meta: true);

  // 查找下一个: F3 或 Ctrl/Cmd + G
  static const findNext = SingleActivator(LogicalKeyboardKey.f3);

  // 替换: Ctrl/Cmd + Shift + F
  static const replace = SingleActivator(LogicalKeyboardKey.keyF, control: true, meta: true, shift: true);

  // 关闭面板: Escape
  static const closePanel = SingleActivator(LogicalKeyboardKey.escape);

  /// 注册全局快捷键（桌面端）
  static Map<ShortcutActivator, Intent> get shortcutMap => {
        typeset: const TypesetIntent(),
        clear: const ClearIntent(),
        copyResult: const CopyResultIntent(),
        swapText: const SwapTextIntent(),
        find: const FindIntent(),
        replace: const ReplaceIntent(),
      };
}

/// 自定义 Intent
class TypesetIntent extends Intent {
  const TypesetIntent();
}

class ClearIntent extends Intent {
  const ClearIntent();
}

class CopyResultIntent extends Intent {
  const CopyResultIntent();
}

class SwapTextIntent extends Intent {
  const SwapTextIntent();
}

class FindIntent extends Intent {
  const FindIntent();
}

class ReplaceIntent extends Intent {
  const ReplaceIntent();
}

class ClosePanelIntent extends Intent {
  const ClosePanelIntent();
}
