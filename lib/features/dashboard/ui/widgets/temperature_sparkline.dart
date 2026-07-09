import 'package:flutter/material.dart';

class TemperatureSparkline extends StatelessWidget {

  const TemperatureSparkline({
    super.key,
    required this.dataPoints,
    this.width = 100.0,
    this.height = 40.0,
  });
  final List<double> dataPoints;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _SparklinePainter(dataPoints: dataPoints),
    );
  }
}

class _SparklinePainter extends CustomPainter {

  _SparklinePainter({required this.dataPoints});
  final List<double> dataPoints;

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.length < 2) return;

    final paint = Paint()
      ..color = const Color(0xFFE05A47)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    final double minVal = dataPoints.reduce((a, b) => a < b ? a : b) - 2;
    final double maxVal = dataPoints.reduce((a, b) => a > b ? a : b) + 2;
    final double valRange = maxVal - minVal == 0 ? 1 : maxVal - minVal;

    final double stepX = size.width / (dataPoints.length - 1);

    double getX(int index) => index * stepX;
    double getY(double val) {
      final double pct = (val - minVal) / valRange;
      return size.height - (pct * size.height);
    }

    path.moveTo(getX(0), getY(dataPoints[0]));

    for (int i = 0; i < dataPoints.length - 1; i++) {
      final x1 = getX(i);
      final y1 = getY(dataPoints[i]);
      final x2 = getX(i + 1);
      final y2 = getY(dataPoints[i + 1]);

      path.cubicTo(x1 + (x2 - x1) / 2, y1, x1 + (x2 - x1) / 2, y2, x2, y2);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints;
  }
}
