import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../data/models/user_model.dart';

class ProfileInfoWidget extends StatelessWidget {
  final UserModel user;
  final VoidCallback onPickImage;

  const ProfileInfoWidget({
    super.key,
    required this.user,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24.r),
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
          Stack(
            children: [
              CircleAvatar(
                radius: 55.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: CircleAvatar(
                  radius: 52.r,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: user.profilePic != null && user.profilePic!.isNotEmpty
                      ? (user.profilePic!.startsWith('http') 
                          ? NetworkImage(user.profilePic!) as ImageProvider
                          : FileImage(File(user.profilePic!)))
                      : null,
                  child: user.profilePic == null || user.profilePic!.isEmpty
                      ? Icon(Icons.person, size: 50.sp, color: Colors.grey)
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onPickImage,
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 16.sp),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            user.name,
            style: AppTextStyles.headlineMd.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            user.email,
            style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
