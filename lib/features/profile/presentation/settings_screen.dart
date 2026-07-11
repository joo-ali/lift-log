import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/features/profile/presentation/widgets/settings_section_header.dart';
import 'package:lift_log/features/profile/presentation/widgets/settings_tile.dart';
import 'package:lift_log/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          l10n.settings,
          style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.r),
        children: [
          const SettingsSectionHeader(title: 'Notifications'),
          const SettingsTile(icon: Icons.notifications_outlined, title: 'Workout Reminders', switchValue: true),
          const SettingsTile(icon: Icons.celebration_outlined, title: 'Achievements Alerts', switchValue: false),
          
          SizedBox(height: 20.h),
          const SettingsSectionHeader(title: 'Units & Measurement'),
          const SettingsTile(icon: Icons.monitor_weight_outlined, title: 'Weight Unit', trailing: 'KG'),
          const SettingsTile(icon: Icons.straighten, title: 'Distance Unit', trailing: 'KM'),

          SizedBox(height: 20.h),
          const SettingsSectionHeader(title: 'Account'),
          const SettingsTile(icon: Icons.cloud_upload_outlined, title: 'Backup Data', trailing: 'Firestore'),
          const SettingsTile(icon: Icons.delete_forever_outlined, title: 'Delete Account', color: Colors.red),
        ],
      ),
    );
  }
}
