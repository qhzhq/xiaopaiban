import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';

/// 关于对话框
class AboutAppDialog extends StatelessWidget {
  const AboutAppDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 应用图标
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.text_fields,
                size: 32,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            // 应用名称
            Text(
              AppConstants.appName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            // 版本号
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'v${AppConstants.appVersion}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 描述
            Text(
              AppConstants.appDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // 分隔线
            Divider(color: theme.dividerColor),
            const SizedBox(height: 16),
            // 功能特性
            _buildFeatureItem(theme, Icons.auto_fix_high, '一键排版', '智能文本格式化'),
            const SizedBox(height: 8),
            _buildFeatureItem(theme, Icons.swap_horiz, '全角半角', '快速字符转换'),
            const SizedBox(height: 8),
            _buildFeatureItem(theme, Icons.text_format, '标点修正', '智能标点符号处理'),
            const SizedBox(height: 8),
            _buildFeatureItem(theme, Icons.desktop_windows, '跨平台', '支持 Windows/macOS/Linux'),
            const SizedBox(height: 24),
            // 链接
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLinkButton(
                  theme,
                  icon: Icons.code,
                  label: 'GitHub',
                  onTap: () => _launchUrl(AppConstants.appWebsite),
                ),
                const SizedBox(width: 16),
                _buildLinkButton(
                  theme,
                  icon: Icons.bug_report_outlined,
                  label: '反馈问题',
                  onTap: () => _launchUrl('${AppConstants.appWebsite}/issues'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // 关闭按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(ThemeData theme, IconData icon, String title, String desc) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                desc,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinkButton(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
