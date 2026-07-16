import 'package:flutter/material.dart';
import 'package:lift_log/core/constants/app_colors.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String actionText;
  final VoidCallback onActionPressed;
  final String cancelText;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actionText,
    required this.onActionPressed,
    this.cancelText = 'Cancel',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      backgroundColor: theme.cardTheme.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
      ),
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: onActionPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: Text(actionText, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

