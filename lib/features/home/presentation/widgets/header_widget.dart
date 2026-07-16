import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/core/theme/theme_cubit.dart';
import 'package:lift_log/l10n/app_localizations.dart';

class HeaderWidget extends StatelessWidget {
  final String userName;

  const HeaderWidget({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Row(
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(Icons.person, color: AppColors.primary, size: 28.sp),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.welcomeBack,
              style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
            ),
            Text(
              userName,
              style: AppTextStyles.headlineMd.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              shape: BoxShape.circle,
              boxShadow: [
                if (theme.brightness == Brightness.light)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
              ],
            ),
            child: Icon(
              theme.brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
              color: theme.colorScheme.onSurface,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }
}
