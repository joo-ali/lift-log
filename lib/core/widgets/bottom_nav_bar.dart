import 'package:flutter/material.dart';
import 'package:lift_log/core/constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: AppColors.surfaceContainer,
      indicatorColor: AppColors.primary.withValues(alpha: 0.1),
      height: 70,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: Colors.grey),
          selectedIcon: Icon(Icons.home, color: AppColors.primary),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined, color: Colors.grey),
          selectedIcon: Icon(Icons.fitness_center, color: AppColors.primary),
          label: 'Workout',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined, color: Colors.grey),
          selectedIcon: Icon(Icons.bar_chart, color: AppColors.primary),
          label: 'Progress',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, color: Colors.grey),
          selectedIcon: Icon(Icons.person, color: AppColors.primary),
          label: 'Profile',
        ),
      ],
    );
  }
}
