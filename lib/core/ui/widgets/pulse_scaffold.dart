import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';

class PulseScaffold extends StatelessWidget {

  const PulseScaffold({super.key, required this.body, this.appBar});
  final Widget body;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cardBackground, Color(0xFF0A0A0B)],
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
