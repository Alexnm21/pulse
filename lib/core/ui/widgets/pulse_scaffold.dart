import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';

class PulseScaffold extends StatelessWidget {
  const PulseScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.gradientColors = const [AppColors.cardBackground, Color(0xFF0A0A0B)],
  });
  final Widget body;
  final PreferredSizeWidget? appBar;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
      ),
    );
  }
}
