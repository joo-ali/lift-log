import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/data/models/workout_model.dart';
import 'package:lift_log/features/progress/presentation/widgets/personal_record_item.dart';
import 'package:lift_log/features/progress/presentation/widgets/progress_header.dart';
import 'package:lift_log/features/progress/presentation/widgets/progress_streak_card.dart';
import 'package:lift_log/features/progress/presentation/widgets/volume_progression_chart.dart';
import 'package:lift_log/features/progress/presentation/widgets/weight_tracking_card.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/widgets/stat_card.dart';
import 'package:lift_log/features/progress/cubit/progress_cubit.dart';
import 'package:lift_log/core/di/service_locator.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => sl<ProgressCubit>()..loadProgress(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<ProgressCubit, ProgressState>(
            builder: (context, state) {
              if (state is ProgressLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              if (state is ProgressError) {
                return Center(child: Text(state.message, style: TextStyle(color: theme.colorScheme.onSurface)));
              }
              if (state is ProgressLoaded) {
                final data = state.data;
                final l10n = AppLocalizations.of(context)!;
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProgressHeader(),
                      SizedBox(height: 30.h),
                      Text(
                        l10n.yourProgress,
                        style: AppTextStyles.displayLg.copyWith(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.trackGains,
                        style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                      ),
                      SizedBox(height: 25.h),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: l10n.totalWorkouts,
                              value: data['totalWorkouts'].toString(),
                              icon: Icons.calendar_today_outlined,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: StatCard(
                              title: l10n.totalVolume,
                              value: (data['totalVolume'] / 1000).toStringAsFixed(1) + 'k',
                              unit: l10n.kg,
                              icon: Icons.fitness_center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      ProgressStreakCard(streak: data['streak'] ?? 0),
                      SizedBox(height: 30.h),
                      VolumeProgressionChart(
                        workouts: List<WorkoutModel>.from(data['workouts'] ?? []),
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        l10n.personalRecords,
                        style: AppTextStyles.headlineMd.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      ...(data['personalRecords'] as Map<String, double>).entries.map((e) {
                        return PersonalRecordItem(
                          icon: Icons.fitness_center,
                          title: e.key,
                          subtitle: '1RM',
                          value: e.value.toString(),
                          unit: l10n.kg,
                        );
                      }),
                      SizedBox(height: 30.h),
                      WeightTrackingCard(
                        currentWeight: data['currentWeight'] ?? 0.0,
                        targetWeight: data['targetWeight'] ?? 0.0,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class ChartLinePainter extends CustomPainter {
  final List<double> volumes;
  final Color color;

  ChartLinePainter({required this.volumes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (volumes.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.2), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    double maxVol = volumes.reduce((a, b) => a > b ? a : b);
    if (maxVol == 0) maxVol = 1;

    double xStep = size.width / (volumes.length > 1 ? volumes.length - 1 : 1);

    for (int i = 0; i < volumes.length; i++) {
      double x = i * xStep;
      double y = size.height - (volumes[i] / maxVol * size.height * 0.8) - (size.height * 0.1);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    final pointPaint = Paint()..color = color;
    final whitePaint = Paint()..color = Colors.white;

    for (int i = 0; i < volumes.length; i++) {
      double x = i * xStep;
      double y = size.height - (volumes[i] / maxVol * size.height * 0.8) - (size.height * 0.1);
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
      canvas.drawCircle(Offset(x, y), 2, whitePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
