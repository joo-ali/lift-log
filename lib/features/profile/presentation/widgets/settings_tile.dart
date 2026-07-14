import 'package:flutter/material.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool? switchValue;
  final String? trailing;
  final Color? color;
  final ValueChanged<bool>? onSwitchChanged;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.switchValue,
    this.trailing,
    this.color,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyLg.copyWith(color: color)),
      trailing: switchValue != null 
          ? Switch(
              value: switchValue!, 
              onChanged: onSwitchChanged ?? (val) {}, 
              activeThumbColor: AppColors.primary,
            )
          : (trailing != null 
              ? Text(trailing!, style: const TextStyle(color: Colors.grey)) 
              : const Icon(Icons.chevron_right, size: 20)),
    );
  }
}
