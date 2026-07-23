import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';
import '../models/preset.dart';
import '../providers/app_state.dart';
import '../utils/text_utils.dart';

/// 设置面板
class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    final settings = appState.settings;

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(left: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          // 标题栏
          _buildHeader(context, theme),
          // 设置内容
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 预设选择
                _buildSectionTitle(theme, '快速预设'),
                const SizedBox(height: 8),
                _buildPresetSelector(context, theme, appState),
                const SizedBox(height: 20),

                // 排版设置
                _buildSectionTitle(theme, '排版设置'),
                const SizedBox(height: 12),
                _buildIndentationSlider(context, theme, settings, appState),
                const SizedBox(height: 12),
                _buildSpacesSlider(context, theme, settings, appState),
                const SizedBox(height: 12),
                _buildLineBreaksSlider(context, theme, settings, appState),
                const SizedBox(height: 20),

                // 文本处理
                _buildSectionTitle(theme, '文本处理'),
                const SizedBox(height: 12),
                _buildFullHalfDropdown(context, theme, settings, appState),
                const SizedBox(height: 12),
                _buildPunctuationDropdown(context, theme, settings, appState),
                const SizedBox(height: 12),
                _buildWaveDropdown(context, theme, settings, appState),
                const SizedBox(height: 20),

                // 界面设置
                _buildSectionTitle(theme, '界面设置'),
                const SizedBox(height: 12),
                _buildFontSizeSlider(context, theme, settings, appState),
                const SizedBox(height: 12),
                _buildThemeSelector(context, theme, settings, appState),
                const SizedBox(height: 12),
                _buildAutoTypesetSwitch(context, theme, settings, appState),
                const SizedBox(height: 20),

                // 重置按钮
                _buildResetButton(context, theme, appState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          Icon(Icons.tune, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            '排版设置',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => context.read<AppState>().setShowSettings(false),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface.withOpacity(0.8),
      ),
    );
  }

  Widget _buildPresetSelector(
    BuildContext context,
    ThemeData theme,
    AppState appState,
  ) {
    final presets = Preset.builtInPresets;
    final activePreset = appState.activePreset;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets.map((preset) {
        final isActive = activePreset == preset.id;
        return InkWell(
          onTap: () => appState.applyPreset(preset),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isActive
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.colorScheme.onSurface.withOpacity(0.04),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.dividerColor,
                width: isActive ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(preset.icon, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  preset.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIndentationSlider(
    BuildContext context,
    ThemeData theme,
    AppSettings settings,
    AppState appState,
  ) {
    return _buildSliderSetting(
      theme,
      label: '段首缩进',
      value: settings.indentation.toDouble(),
      min: 0,
      max: 8,
      divisions: 8,
      suffix: '字符',
      onChanged: (value) {
        appState.updateSettings(
          settings.copyWith(indentation: value.round()),
        );
      },
    );
  }

  Widget _buildSpacesSlider(
    BuildContext context,
    ThemeData theme,
    AppSettings settings,
    AppState appState,
  ) {
    return _buildSliderSetting(
      theme,
      label: '段间空行',
      value: settings.spaces.toDouble(),
      min: 0,
      max: 3,
      divisions: 3,
      suffix: '行',
      onChanged: (value) {
        appState.updateSettings(
          settings.copyWith(spaces: value.round()),
        );
      },
    );
  }

  Widget _buildLineBreaksSlider(
    BuildContext context,
    ThemeData theme,
    AppSettings settings,
    AppState appState,
  ) {
    return _buildSliderSetting(
      theme,
      label: '段内换行',
      value: settings.lineBreaks.toDouble(),
      min: 1,
      max: 5,
      divisions: 4,
      suffix: '行',
      onChanged: (value) {
        appState.updateSettings(
          settings.copyWith(lineBreaks: value.round()),
        );
      },
    );
  }

  Widget _buildSliderSetting(
    ThemeData theme, {
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String suffix,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${value.round()} $suffix',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: theme.colorScheme.primary,
            inactiveTrackColor: theme.colorScheme.onSurface.withOpacity(0.1),
            thumbColor: theme.colorScheme.primary,
            overlayColor: theme.colorScheme.primary.withOpacity(0.1),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildFullHalfDropdown(
    BuildContext context,
    ThemeData theme,
    AppSettings settings,
    AppState appState,
  ) {
    return _buildDropdownSetting<int>(
      theme,
      label: '全角半角',
      value: settings.fullHalf,
      items: [
        const DropdownMenuItem(value: 0, child: Text('保持不变')),
        const DropdownMenuItem(value: 1, child: Text('字母→半角')),
        const DropdownMenuItem(value: 2, child: Text('字母→全角')),
        const DropdownMenuItem(value: 3, child: Text('数字→半角')),
        const DropdownMenuItem(value: 4, child: Text('数字→全角')),
        const DropdownMenuItem(value: 5, child: Text('全部→半角')),
        const DropdownMenuItem(value: 6, child: Text('全部→全角')),
      ],
      onChanged: (value) {
        if (value != null) {
          appState.updateSettings(settings.copyWith(fullHalf: value));
        }
      },
    );
  }

  Widget _buildPunctuationDropdown(
    BuildContext context,
    ThemeData theme,
    AppSettings settings,
    AppState appState,
  ) {
    return _buildDropdownSetting<int>(
      theme,
      label: '标点修正',
      value: settings.punctuation,
      items: [
        const DropdownMenuItem(value: 0, child: Text('保持不变')),
        const DropdownMenuItem(value: 1, child: Text('中文→英文标点')),
        const DropdownMenuItem(value: 2, child: Text('英文→中文标点')),
        const DropdownMenuItem(value: 3, child: Text('去除重复标点')),
        const DropdownMenuItem(value: 4, child: Text('智能修正所有')),
      ],
      onChanged: (value) {
        if (value != null) {
          appState.updateSettings(settings.copyWith(punctuation: value));
        }
      },
    );
  }

  Widget _buildWaveDropdown(
    BuildContext context,
    ThemeData theme,
    AppSettings settings,
    AppState appState,
  ) {
    return _buildDropdownSetting<int>(
      theme,
      label: '波浪线修正',
      value: settings.wave,
      items: [
        const DropdownMenuItem(value: 0, child: Text('保持不变')),
        const DropdownMenuItem(value: 1, child: Text('→ ～')),
        const DropdownMenuItem(value: 2, child: Text('→ ~')),
        const DropdownMenuItem(value: 3, child: Text('→ ——')),
        const DropdownMenuItem(value: 4, child: Text('统一修正')),
      ],
      onChanged: (value) {
        if (value != null) {
          appState.updateSettings(settings.copyWith(wave: value));
        }
      },
    );
  }

  Widget _buildDropdownSetting<T>(
    ThemeData theme, {
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButton<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            style: theme.textTheme.bodyMedium,
            dropdownColor: theme.colorScheme.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildFontSizeSlider(
    BuildContext context,
    ThemeData theme,
    AppSettings settings,
    AppState appState,
  ) {
    return _buildSliderSetting(
      theme,
      label: '字体大小',
      value: settings.fontSize,
      min: 12,
      max: 20,
      divisions: 8,
      suffix: 'px',
      onChanged: (value) {
        appState.updateSettings(settings.copyWith(fontSize: value));
      },
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    ThemeData theme,
    AppSettings settings,
    AppState appState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '主题',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildThemeOption(
              context, theme, appState,
              icon: Icons.light_mode,
              label: '浅色',
              value: 'light',
              current: settings.theme,
            ),
            const SizedBox(width: 8),
            _buildThemeOption(
              context, theme, appState,
              icon: Icons.dark_mode,
              label: '深色',
              value: 'dark',
              current: settings.theme,
            ),
            const SizedBox(width: 8),
            _buildThemeOption(
              context, theme, appState,
              icon: Icons.brightness_auto,
              label: '跟随系统',
              value: 'auto',
              current: settings.theme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeData theme,
    AppState appState, {
    required IconData icon,
    required String label,
    required String value,
    required String current,
  }) {
    final isActive = current == value;
    return Expanded(
      child: InkWell(
        onTap: () => appState.updateSettings(
          appState.settings.copyWith(theme: value),
        ),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.colorScheme.onSurface.withOpacity(0.04),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAutoTypesetSwitch(
    BuildContext context,
    ThemeData theme,
    AppSettings settings,
    AppState appState,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '自动排版',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Switch(
          value: settings.autoTypeset,
          onChanged: (value) {
            appState.updateSettings(settings.copyWith(autoTypeset: value));
          },
        ),
      ],
    );
  }

  Widget _buildResetButton(
    BuildContext context,
    ThemeData theme,
    AppState appState,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('重置设置'),
              content: const Text('确定要重置所有设置为默认值吗？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    appState.resetSettings();
                  },
                  child: const Text('重置'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.restore, size: 16),
        label: const Text('重置为默认设置'),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface.withOpacity(0.6),
          side: BorderSide(color: theme.dividerColor),
        ),
      ),
    );
  }
}
