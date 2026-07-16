import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class LabelDivider extends StatelessWidget {
  final String label;

  const LabelDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: Theme.of(context).textTheme.labelSmall?.color?.withOpacity(0.5),
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}


