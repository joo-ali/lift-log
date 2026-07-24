import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/l10n/app_localizations.dart';

class ProfileTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onEdit;

  const ProfileTopBar({
    super.key,
    required this.onBack,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),
        ),
        Text(
          l10n.profile,
          style: AppTextStyles.headlineMd.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit_outlined, color: AppColors.primary, size: 20.sp),
          ),
        ),
      ],
    );
  }
}


