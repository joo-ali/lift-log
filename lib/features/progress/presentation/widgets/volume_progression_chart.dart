import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/data/models/workout_model.dart';
import 'package:lift_log/l10n/app_localizations.dart';

class VolumeProgressionChart extends StatelessWidget {
  final List<WorkoutModel> workouts;

  const VolumeProgressionChart({
    super.key,
    required this.workouts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final recentWorkouts = workouts.length > 7 ? workouts.sublist(workouts.length - 7) : workouts;
    final List<double> volumes = recentWorkouts.map((w) => w.totalVolume).toList();
    // تأكد من وجود بيانات كافية للرسم
    final labels = recentWorkouts.map((w) => DateFormat('E', locale).format(w.date)).toList();

    return Container(
      constraints: BoxConstraints(minHeight: 200.h),
      padding: EdgeInsets.all(20.r),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.volumeProgression,
            style: AppTextStyles.headlineMd.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30.h),
          if (volumes.isEmpty)
            Center(
              child: Text(
                l10n.addWorkoutsToSeeProgress,
                style: const TextStyle(color: Colors.grey),
              ),
            )
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
                        return Text(
                          day,
                          style: AppTextStyles.labelSm.copyWith(color: Colors.grey),
                        );
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
