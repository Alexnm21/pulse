import 'package:flutter/material.dart';
import 'package:pulse/core/extensions/widgetx.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/app_fonts.dart';
import 'package:pulse/features/dashboard/domain/enums/cpu_state.dart';
import 'package:pulse/features/dashboard/ui/extensions/cpu_state_ext.dart';

class CpuStateChip extends StatelessWidget {
  final CpuState cpuState;
  const CpuStateChip({super.key, required this.cpuState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.chipColor,
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 6, backgroundColor: cpuState.color),
          Text(
            cpuState.displayName(context),
            style: AppFonts.bodyMedium.copyWith(color: Colors.white),
          ).withPaddingSymmetric(horizontal: 8),
        ],
      ),
    );
  }
}
