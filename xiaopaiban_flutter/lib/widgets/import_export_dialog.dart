import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

/// 导出对话框
class ExportDialog extends StatelessWidget {
  const ExportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    final exportData = appState.exportSettings();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Icon(Icons.file_download_outlined, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '导出设置',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 说明
            Text(
              '以下是您的设置和历史记录数据，可以复制保存以备将来导入。',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            // 数据预览
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.04),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.dividerColor),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  exportData,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 操作按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: exportData));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('已复制到剪贴板')),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('复制'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('完成'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 导入对话框
class ImportDialog extends StatefulWidget {
  const ImportDialog({super.key});

  @override
  State<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Icon(Icons.file_upload_outlined, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '导入设置',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 说明
            Text(
              '粘贴之前导出的设置数据以恢复您的配置。',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            // 输入框
            TextField(
              controller: _controller,
              maxLines: 8,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              decoration: InputDecoration(
                hintText: '粘贴导出的 JSON 数据...',
                errorText: _error,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),
            // 操作按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    final data = _controller.text.trim();
                    if (data.isEmpty) {
                      setState(() => _error = '请输入数据');
                      return;
                    }
                    final appState = context.read<AppState>();
                    final success = appState.importSettings(data);
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('导入成功')),
                      );
                    } else {
                      setState(() => _error = '数据格式无效');
                    }
                  },
                  icon: const Icon(Icons.upload, size: 16),
                  label: const Text('导入'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
