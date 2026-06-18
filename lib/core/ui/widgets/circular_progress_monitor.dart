import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';

class CircularProgressMonitor extends StatelessWidget {
  final double value;
  final String title;
  final double size;
  final Color progressColor;

  const CircularProgressMonitor({
    super.key,
    required this.value,
    required this.title,
    this.size = 200.0,
    this.progressColor = const Color(0xffa4bcff),
  });

  @override
  Widget build(BuildContext context) {
    final double cleanValue = value.clamp(0.0, 100.0);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: cleanValue),
      duration: const Duration(milliseconds: 300),
      curve: Curves.decelerate,
      builder: (context, animatedValue, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _TrackAndProgressPainter(
                    percentage: animatedValue,
                    progressColor: progressColor,
                    trackColor: AppColors.white008,
                    strokeWidth: size * 0.09,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${animatedValue.toStringAsFixed(1)}%",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.white050,
                      fontSize: size * 0.07,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TrackAndProgressPainter extends CustomPainter {
  final double percentage;
  final Color progressColor;
  final Color trackColor;
  final double strokeWidth;

  _TrackAndProgressPainter({
    required this.percentage,
    required this.progressColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    if (percentage <= 0) return;

    const startAngle = -math.pi / 2;
    final sweepAngle = (percentage / 100.0) * (2 * math.pi);

    final glowPaint = Paint()
      ..color = progressColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 1.3
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      glowPaint,
    );

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TrackAndProgressPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.progressColor != progressColor;
  }
}
