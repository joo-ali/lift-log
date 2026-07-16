import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final TextEditingController controller;
  final VoidCallback? onToggleVisibility;
  final TextInputType? keyboardType;
  final String? suffixText;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    required this.controller,
    this.onToggleVisibility,
    this.keyboardType,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        TextField(
          controller: controller,
          obscureText: isPassword && obscureText,
          keyboardType: keyboardType,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: theme.hintColor),
            prefixIcon: Icon(icon, color: theme.iconTheme.color?.withValues(alpha: 0.5)),
            suffixText: suffixText,
            suffixStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: theme.iconTheme.color?.withValues(alpha: 0.5),
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            filled: true,
            fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: theme.primaryColor, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}

