import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart';
import 'providers/app_state.dart';
import 'services/storage_service.dart';
import 'services/window_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化窗口管理（桌面端）
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    
    final storage = await StorageService.getInstance();
    final windowSize = storage.loadWindowSize();

    final windowOptions = WindowOptions(
      size: Size(
        windowSize?['width'] ?? AppConstants.defaultWindowWidth,
        windowSize?['height'] ?? AppConstants.defaultWindowHeight,
      ),
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
  }

  // 初始化存储服务
  final storage = await StorageService.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(storage),
      child: const XiaopaiBanApp(),
    ),
  );
}
