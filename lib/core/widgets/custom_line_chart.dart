import 'package:flutter/material.dart';

class CustomLineChart extends StatelessWidget {
  final List<double> data;
  final Color color;
  final double height;

  const CustomLineChart({
    super.key,
    required this.data,
    required this.color,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _ChartLinePainter(volumes: data, color: color),
      ),
    );
  }
}

class _ChartLinePainter extends CustomPainter {
  final List<double> volumes;
  final Color color;

  _ChartLinePainter({required this.volumes, required this.color});

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
