import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/widgets/stat_card.dart';
import 'package:lift_log/l10n/app_localizations.dart';

class ProfileStatsGrid extends StatelessWidget {
  final int workoutCount;
  final int streak;

  const ProfileStatsGrid({
    super.key,
    required this.workoutCount,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: l10n.workoutsCount,
            value: workoutCount.toString(),
            icon: Icons.fitness_center,
            isVertical: true,
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: StatCard(
            title: l10n.streak,
            value: streak.toString(),
            icon: Icons.local_fire_department_outlined,
            isVertical: true,
          ),
        ),
      ],
    );
  }
}
