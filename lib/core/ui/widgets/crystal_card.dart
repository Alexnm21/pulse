import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';

class CrystalCard extends StatelessWidget {

  const CrystalCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.blur = 20.0,
    this.padding,
  });
  final Widget child;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: AppColors.white006,
            border: Border.all(
              color: AppColors.white012,
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
