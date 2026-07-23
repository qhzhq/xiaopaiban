import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/history_item.dart';
import '../providers/app_state.dart';

/// 历史记录对话框
class HistoryDialog extends StatelessWidget {
  const HistoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    final history = appState.history;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // 标题栏
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: theme.dividerColor)),
              ),
              child: Row(
                children: [
                  Icon(Icons.history, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '历史记录',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${history.length}',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (history.isNotEmpty)
                    TextButton.icon(
                      onPressed: () => _showClearConfirm(context, appState),
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text('清空'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // 列表
            Expanded(
              child: history.isEmpty
                  ? _buildEmptyState(theme)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return _buildHistoryItem(
                          context, theme, appState, history[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: theme.colorScheme.onSurface.withOpacity(0.2),
          ),
          const SizedBox(height: 12),
          Text(
            '暂无历史记录',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '排版后的记录将自动保存在这里',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    ThemeData theme,
    AppState appState,
    HistoryItem item,
  ) {
    return InkWell(
      onTap: () {
        appState.restoreFromHistory(item);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withOpacity(0.5),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 时间和操作
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
                const SizedBox(width: 4),
                Text(
                  item.formattedTime,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  onPressed: () => appState.deleteHistoryItem(item.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // 预览文本
            Text(
              item.preview,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // 统计信息
            Row(
              children: [
                _buildStatChip(theme, '${item.text.length} 字'),
                const SizedBox(width: 8),
                _buildStatChip(theme, '缩进 ${item.settings.indentation}'),
                const SizedBox(width: 8),
                _buildStatChip(theme, '空行 ${item.settings.spaces}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(ThemeData theme, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.06),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
    );
  }

  void _showClearConfirm(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('清空历史记录'),
        content: const Text('确定要清空所有历史记录吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              appState.clearHistory();
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
