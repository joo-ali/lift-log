import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;
  final bool isLoading;

  const SocialButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey[200]!,
          ),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: 24.r,
                  width: 24.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(iconPath, height: 24.r, width: 24.r),
                  SizedBox(width: 12.w),
                  Text(
                    label,
                    style: AppTextStyles.bodyMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}


