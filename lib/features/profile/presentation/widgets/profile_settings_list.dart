import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../settings_screen.dart';
import 'profile_settings_item.dart';

class ProfileSettingsList extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileSettingsList({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            )
        ],
      ),
      child: Column(
        children: [
          ProfileSettingsItem(
            icon: Icons.settings_outlined,
            title: l10n.settings,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          Divider(color: theme.brightness == Brightness.dark ? Colors.black26 : Colors.grey[100], height: 1),
          BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return ProfileSettingsItem(
                icon: Icons.language,
                title: l10n.language,
                trailing: Text(
                  locale.languageCode == 'ar' ? 'العربية' : 'English',
                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary),
                ),
                onTap: () {
                  context.read<LocaleCubit>().toggleLocale();
                },
              );
            },
          ),
          Divider(color: theme.brightness == Brightness.dark ? Colors.black26 : Colors.grey[100], height: 1),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return ProfileSettingsItem(
                icon: Icons.dark_mode_outlined,
                title: l10n.darkMode,
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  activeThumbColor: AppColors.primary,
                  onChanged: (value) {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                ),
              );
            },
          ),
          Divider(color: theme.brightness == Brightness.dark ? Colors.black26 : Colors.grey[100], height: 1),
          ProfileSettingsItem(
            icon: Icons.info_outline,
            title: l10n.aboutApp,
            onTap: () {},
          ),
          Divider(color: theme.brightness == Brightness.dark ? Colors.black26 : Colors.grey[100], height: 1),
          ProfileSettingsItem(
            icon: Icons.logout,
            title: l10n.logout,
            titleColor: AppColors.primary,
            iconColor: AppColors.primary,
            showChevron: false,
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
