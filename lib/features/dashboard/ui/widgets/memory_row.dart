import 'package:flutter/material.dart';
import 'package:pulse/core/extensions/doublex.dart';
import 'package:pulse/core/extensions/widgetx.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/app_fonts.dart';

class MemoryRow extends StatelessWidget {
  final Color color;
  final String text;
  final double value;

  const MemoryRow({
    super.key,
    required this.color,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 4,
          backgroundColor: color,
        ).withPaddingOnly(right: 8),
        Text(
          text,
          style: AppFonts.bodyMedium.copyWith(color: AppColors.unselectedColor),
        ),
        const Spacer(),
        Text(
          '${value.toOneDecimal} GB',
          style: AppFonts.bodyLarge.copyWith(color: AppColors.background),
        ),
      ],
    );
  }
}
