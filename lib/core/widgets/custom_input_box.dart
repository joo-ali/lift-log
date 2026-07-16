import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class CustomInputBox extends StatelessWidget {
  final String initialValue;
  final Function(String) onChanged;
  final double? width;
  final double? height;
  final TextInputType keyboardType;

  const CustomInputBox({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.width,
    this.height,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width ?? 80.w,
      height: height ?? 40.h,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyLg.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.only(top: 8),
        ),
      ),
    );
  }
}


