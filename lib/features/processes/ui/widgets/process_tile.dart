import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/app_fonts.dart';
import 'package:pulse/features/processes/domain/entities/process_entity.dart';

class ProcessTile extends StatelessWidget {

  const ProcessTile({super.key, required this.process});
  final ProcessEntity process;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.chipColor,
        child: Text(
          process.name[0].toUpperCase(),
          style: AppFonts.bodyMedium.copyWith(color: Colors.white),
        ),
      ),
      title: Text(
        process.name,
        style: AppFonts.bodyLarge.copyWith(color: Colors.white),
      ),
      subtitle: Text(
        process.user,
        style: AppFonts.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
      trailing: SizedBox(
        width: 120,
        child: Row(
          children: [
            Expanded(
              child: _MiniBar(value: process.cpuUsage, color: AppColors.selectedColor),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MiniBar(value: process.memoryUsage, color: AppColors.critical),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBar extends StatelessWidget {

  const _MiniBar({required this.value, required this.color});
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${value.toStringAsFixed(1)}%',
          style: AppFonts.bodySmall.copyWith(color: color, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Container(
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: AppColors.chipColor,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0) / 100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
