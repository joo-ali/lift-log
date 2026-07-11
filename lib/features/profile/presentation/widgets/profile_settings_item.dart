import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_text_styles.dart';

class ProfileSettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Color? titleColor;
  final Color? iconColor;
  final bool showChevron;
  final VoidCallback? onTap;

  const ProfileSettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.titleColor,
    this.iconColor,
    this.showChevron = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: iconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.7),
        size: 22.sp,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLg.copyWith(color: titleColor ?? theme.colorScheme.onSurface),
      ),
      trailing: trailing ?? (showChevron ? Icon(Icons.chevron_right, color: Colors.grey, size: 20.sp) : null),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
    );
  }
}
