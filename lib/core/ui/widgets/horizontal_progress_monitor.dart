import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';

class HorizontalProgressMonitor extends StatelessWidget {
  const HorizontalProgressMonitor({
    super.key,
    required this.value,
    this.height = 14.0,
    this.useGradient = true,
    this.progressColor,
  });
  final double value;
  final double height;
  final bool useGradient;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    final double cleanValue = value.clamp(0.0, 100.0);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: cleanValue),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return CustomPaint(
          size: Size(double.infinity, height),
          painter: _HorizontalLinearProgressPainter(
            percentage: animatedValue,
            useGradient: useGradient,
            progressColor: progressColor ?? AppColors.selectedColor,
          ),
        );
      },
    );
  }
}

class _HorizontalLinearProgressPainter extends CustomPainter {
  _HorizontalLinearProgressPainter({
    required this.percentage,
    required this.useGradient,
    required this.progressColor,
  });
  static const _gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF76E28E), Color(0xFFE9D460), Color(0xFFE05A47)],
    stops: [0.0, 0.5, 1.0],
  );

  final double percentage;
  final bool useGradient;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final RRect trackRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.height / 2),
    );

    final Paint trackPaint = Paint()
      ..color = const Color(0xFF1E1E20)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRRect, trackPaint);

    final Paint borderPaint = Paint()
      ..color = AppColors.white004
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(trackRRect, borderPaint);

    if (percentage <= 0) return;

    final double progressWidth = (percentage / 100.0) * size.width;

    final RRect progressRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, progressWidth, size.height),
      Radius.circular(size.height / 2),
    );

    final Paint progressPaint = Paint()..style = PaintingStyle.fill;

    if (useGradient) {
      progressPaint.shader = _gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    } else {
      progressPaint.color = progressColor;
    }

    canvas.save();
    canvas.clipRRect(trackRRect);
    canvas.drawRRect(progressRRect, progressPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HorizontalLinearProgressPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
