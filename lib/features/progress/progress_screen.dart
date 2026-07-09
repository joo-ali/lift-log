import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/data/models/workout_model.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'cubit/progress_cubit.dart';
import '../../../core/di/service_locator.dart';

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
                      _buildHeader(context),
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
                          Expanded(child: _buildMainStatCard(context, l10n.totalWorkouts, data['totalWorkouts'].toString(), Icons.calendar_today_outlined, '')),
                          SizedBox(width: 15.w),
                          Expanded(child: _buildMainStatCard(context, l10n.totalVolume, (data['totalVolume'] / 1000).toStringAsFixed(1) + 'k', Icons.fitness_center, l10n.kg)),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      _buildStreakBar(context, data['streak'] ?? 0),
                      SizedBox(height: 30.h),
                      _buildVolumeProgressionSection(context, List<WorkoutModel>.from(data['workouts'] ?? [])),
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
                        return _buildPRItem(context, Icons.fitness_center, e.key, '1RM', e.value.toString(), l10n.kg);
                      }),
                      SizedBox(height: 30.h),
                      _buildWeightTrackingSection(context, data['currentWeight'] ?? 0.0, data['targetWeight'] ?? 0.0),
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(Icons.person, color: AppColors.primary, size: 20.sp),
        ),
        Text(
          'LiftLog',
          style: AppTextStyles.headlineMd.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Icon(Icons.settings_outlined, color: Theme.of(context).colorScheme.onSurface),
      ],
    );
  }

  Widget _buildMainStatCard(BuildContext context, String label, String value, IconData icon, String unit) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [if (theme.brightness == Brightness.light) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.grey, size: 20.sp),
              Text(
                label,
                style: AppTextStyles.labelSm.copyWith(color: Colors.grey, fontSize: 10.sp),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          SizedBox(height: 15.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: AppTextStyles.displayLg.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.sp,
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakBar(BuildContext context, int streak) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [if (theme.brightness == Brightness.light) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: AppColors.primary, size: 24.sp),
          SizedBox(width: 12.w),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: streak.toString(),
                  style: AppTextStyles.headlineLg.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' ${l10n.days}',
                  style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            l10n.streak,
            style: AppTextStyles.labelSm.copyWith(color: AppColors.primary, letterSpacing: 1.2, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeProgressionSection(BuildContext context, List<WorkoutModel> workouts) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final recentWorkouts = workouts.length > 7 ? workouts.sublist(workouts.length - 7) : workouts;
    final List<double> volumes = recentWorkouts.map((w) => w.totalVolume).toList();
    final labels = recentWorkouts.map((w) => DateFormat('E', locale).format(w.date)).toList();

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [if (theme.brightness == Brightness.light) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.volumeProgression,
            style: AppTextStyles.headlineMd.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30.h),
          if (volumes.isEmpty)
            Center(child: Text(l10n.addWorkoutsToSeeProgress, style: TextStyle(color: Colors.grey)))
          else
            SizedBox(
              height: 150.h,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(double.infinity, 150.h),
                    painter: ChartLinePainter(volumes: volumes, color: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: labels.map((day) {
                        return Text(day, style: AppTextStyles.labelSm.copyWith(color: Colors.grey));
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPRItem(BuildContext context, IconData icon, String title, String sub, String weight, String unit) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [if (theme.brightness == Brightness.light) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        border: Border(left: BorderSide(color: AppColors.primary, width: 4.w)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark ? Colors.black : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.sp),
          ),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyLg.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
              Text(sub, style: AppTextStyles.labelSm.copyWith(color: Colors.grey)),
            ],
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: weight,
                  style: AppTextStyles.headlineMd.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' $unit',
                  style: AppTextStyles.labelSm.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightTrackingSection(BuildContext context, double current, double target) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    double progress = (target > 0) ? (current / target) : 0.0;
    if (progress > 1.0) progress = 1.0;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [if (theme.brightness == Brightness.light) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.scale_outlined, color: Colors.grey, size: 20.sp),
                  SizedBox(width: 10.w),
                  Text(
                    l10n.weightTracking,
                    style: AppTextStyles.headlineMd.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18.sp),
                  ),
                ],
              ),
              if (current > 0 && target > 0)
                Text(l10n.toGoal((target - current).abs().toStringAsFixed(1), l10n.kg), 
                  style: AppTextStyles.labelSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWeightInfo(context, l10n.current, current.toStringAsFixed(1), l10n.kg),
              _buildWeightInfo(context, l10n.target, target.toStringAsFixed(1), l10n.kg, alignRight: true),
            ],
          ),
          SizedBox(height: 15.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.brightness == Brightness.dark ? Colors.black : Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8.h,
          ),
        ],
      ),
    );
  }

  Widget _buildWeightInfo(BuildContext context, String label, String val, String unit, {bool alignRight = false}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSm.copyWith(color: Colors.grey)),
        SizedBox(height: 4.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: val,
                style: AppTextStyles.headlineMd.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' $unit',
                style: AppTextStyles.labelSm.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
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
