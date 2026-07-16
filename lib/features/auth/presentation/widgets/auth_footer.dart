import 'package:flutter/material.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class AuthFooter extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onActionTap;

  const AuthFooter({
    super.key,
    required this.text,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$text ",
          style: AppTextStyles.bodyMd.copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionText,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

