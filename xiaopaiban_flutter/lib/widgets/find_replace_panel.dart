import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../utils/text_utils.dart';

/// 查找替换面板
class FindReplacePanel extends StatefulWidget {
  const FindReplacePanel({super.key});

  @override
  State<FindReplacePanel> createState() => _FindReplacePanelState();
}

class _FindReplacePanelState extends State<FindReplacePanel> {
  final TextEditingController _findController = TextEditingController();
  final TextEditingController _replaceController = TextEditingController();
  final FocusNode _findFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _findFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _findController.dispose();
    _replaceController.dispose();
    _findFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<AppState>(
      builder: (context, state, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFE0E0E0),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 目标面板选择
              Row(
                children: [
                  _buildTargetToggle(state, isDark),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFindRow(state, isDark),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // 替换行
              Row(
                children: [
                  const SizedBox(width: 100), // 对齐上面的目标选择
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildReplaceRow(state, isDark),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建目标面板切换
  Widget _buildTargetToggle(AppState state, bool isDark) {
    return Container(
      width: 100,
      height: 36,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFE0E0E0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => state.setFindTarget(true),
              child: Container(
                decoration: BoxDecoration(
                  color: state.isFindInInput
                      ? (isDark ? const Color(0xFF0D47A1) : const Color(0xFF2196F3))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  '输入',
                  style: TextStyle(
                    fontSize: 12,
                    color: state.isFindInInput
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.black54),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => state.setFindTarget(false),
              child: Container(
                decoration: BoxDecoration(
                  color: !state.isFindInInput
                      ? (isDark ? const Color(0xFF0D47A1) : const Color(0xFF2196F3))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  '输出',
                  style: TextStyle(
                    fontSize: 12,
                    color: !state.isFindInInput
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.black54),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建查找行
  Widget _buildFindRow(AppState state, bool isDark) {
    return Row(
      children: [
        // 查找输入框
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFE0E0E0),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Icon(
                  Icons.search,
                  size: 16,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _findController,
                    focusNode: _findFocus,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: '查找...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (value) {
                      state.setFindQuery(value);
                    },
                    onSubmitted: (_) => state.findNext(),
                  ),
                ),
                // 匹配计数
                if (state.findQuery.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      state.hasMatches
                          ? '${state.currentMatchIndex + 1}/${state.matchCount}'
                          : '无匹配',
                      style: TextStyle(
                        fontSize: 11,
                        color: state.hasMatches
                            ? (isDark ? Colors.white60 : Colors.black54)
                            : Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 上一个
        _buildSmallButton(
          icon: Icons.keyboard_arrow_up,
          tooltip: '上一个 (Shift+Enter)',
          enabled: state.hasMatches,
          isDark: isDark,
          onTap: state.findPrevious,
        ),
        // 下一个
        _buildSmallButton(
          icon: Icons.keyboard_arrow_down,
          tooltip: '下一个 (Enter)',
          enabled: state.hasMatches,
          isDark: isDark,
          onTap: state.findNext,
        ),
        const SizedBox(width: 4),
        // 大小写敏感
        _buildToggleButton(
          icon: Icons.text_fields,
          tooltip: '区分大小写',
          isActive: state.caseSensitive,
          isDark: isDark,
          onTap: state.toggleCaseSensitive,
        ),
        // 全词匹配
        _buildToggleButton(
          icon: Icons.text_format,
          tooltip: '全词匹配',
          isActive: state.wholeWord,
          isDark: isDark,
          onTap: state.toggleWholeWord,
        ),
        // 正则表达式
        _buildToggleButton(
          icon: Icons.code,
          tooltip: '正则表达式',
          isActive: state.useRegex,
          isDark: isDark,
          onTap: state.toggleUseRegex,
        ),
        const SizedBox(width: 4),
        // 关闭按钮
        _buildSmallButton(
          icon: Icons.close,
          tooltip: '关闭 (Escape)',
          isDark: isDark,
          onTap: () => state.toggleFindReplace(),
        ),
      ],
    );
  }

  /// 构建替换行
  Widget _buildReplaceRow(AppState state, bool isDark) {
    return Row(
      children: [
        // 替换输入框
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFE0E0E0),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Icon(
                  Icons.find_replace,
                  size: 16,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _replaceController,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: '替换为...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (value) {
                      state.setReplaceText(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 替换按钮
        SizedBox(
          height: 36,
          child: ElevatedButton(
            onPressed: state.hasCurrentMatch ? state.replaceCurrent : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              foregroundColor: isDark ? Colors.white70 : Colors.black87,
              side: BorderSide(
                color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFE0E0E0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('替换', style: TextStyle(fontSize: 12)),
          ),
        ),
        const SizedBox(width: 8),
        // 全部替换按钮
        SizedBox(
          height: 36,
          child: ElevatedButton(
            onPressed: state.hasMatches ? state.replaceAll : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? const Color(0xFF1565C0) : const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('全部替换', style: TextStyle(fontSize: 12)),
          ),
        ),
      ],
    );
  }

  /// 构建小按钮
  Widget _buildSmallButton({
    required IconData icon,
    required String tooltip,
    required bool isDark,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 32,
          height: 36,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFE0E0E0),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: enabled
                ? (isDark ? Colors.white70 : Colors.black54)
                : (isDark ? Colors.white24 : Colors.black26),
          ),
        ),
      ),
    );
  }

  /// 构建切换按钮
  Widget _buildToggleButton({
    required IconData icon,
    required String tooltip,
    required bool isActive,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 36,
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? const Color(0xFF0D47A1) : const Color(0xFF2196F3))
                : (isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5)),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isActive
                  ? (isDark ? const Color(0xFF1565C0) : const Color(0xFF42A5F5))
                  : (isDark ? const Color(0xFF3E3E3E) : const Color(0xFFE0E0E0)),
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isActive
                ? Colors.white
                : (isDark ? Colors.white54 : Colors.black45),
          ),
        ),
      ),
    );
  }
}
