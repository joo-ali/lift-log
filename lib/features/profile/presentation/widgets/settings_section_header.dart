import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, left: 5.w),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSm.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }
}
