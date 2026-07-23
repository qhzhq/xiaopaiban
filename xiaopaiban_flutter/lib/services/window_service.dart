import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../utils/constants.dart';

/// 窗口管理服务
class WindowService {
  static WindowService? _instance;
  bool _initialized = false;

  WindowService._();

  static WindowService getInstance() {
    _instance ??= WindowService._();
    return _instance!;
  }

  /// 初始化窗口
  Future<void> init({
    double? width,
    double? height,
  }) async {
    if (_initialized) return;
    if (!Platform.isWindows && !Platform.isMacOS && !Platform.isLinux) return;

    await windowManager.ensureInitialized();

    final windowWidth = width ?? AppConstants.defaultWindowWidth;
    final windowHeight = height ?? AppConstants.defaultWindowHeight;

    final windowOptions = WindowOptions(
      size: Size(windowWidth, windowHeight),
      minimumSize: const Size(AppConstants.minWindowWidth, AppConstants.minWindowHeight),
      center: true,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: true,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    _initialized = true;
  }

  /// 设置窗口标题
  Future<void> setTitle(String title) async {
    if (!_initialized) return;
    await windowManager.setTitle(title);
  }

  /// 设置窗口大小
  Future<void> setSize(double width, double height) async {
    if (!_initialized) return;
    await windowManager.setSize(Size(width, height));
  }

  /// 最小化窗口
  Future<void> minimize() async {
    if (!_initialized) return;
    await windowManager.minimize();
  }

  /// 最大化/还原窗口
  Future<void> toggleMaximize() async {
    if (!_initialized) return;
    final isMaximized = await windowManager.isMaximized();
    if (isMaximized) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }

  /// 关闭窗口
  Future<void> close() async {
    if (!_initialized) return;
    await windowManager.close();
  }

  /// 获取窗口大小
  Future<Size> getSize() async {
    if (!_initialized) {
      return const Size(AppConstants.defaultWindowWidth, AppConstants.defaultWindowHeight);
    }
    return await windowManager.getSize();
  }

  /// 检查是否最大化
  Future<bool> isMaximized() async {
    if (!_initialized) return false;
    return await windowManager.isMaximized();
  }
}
