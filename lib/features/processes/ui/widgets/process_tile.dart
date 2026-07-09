import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/extensions/doublex.dart';
import 'package:pulse/core/extensions/widgetx.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/app_fonts.dart';
import 'package:pulse/core/ui/widgets/horizontal_progress_monitor.dart';
import 'package:pulse/features/processes/domain/entities/process_entity.dart';
import 'package:pulse/features/processes/domain/enums/process_list_column.dart';
import 'package:pulse/features/processes/ui/bloc/processes_bloc.dart';

class ProcessTile extends StatelessWidget {
  const ProcessTile({
    super.key,
    required this.process,
    required this.selected,
    required this.maxMemoryMB,
  });
  final ProcessEntity process;
  final bool selected;
  final double maxMemoryMB;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: selected
          ? const BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.selectedColor, width: 4),
              ),
            )
          : null,
      child: InkWell(
        onTap: () => context.read<ProcessesBloc>().selectProcess(process),
        child: Row(
          children: [
            Expanded(
              flex: ProcessListColumn.name.flex,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: selected
                        ? AppColors.selectedColor
                        : AppColors.chipColor,
                    child: Text(
                      process.name[0].toUpperCase(),
                      style: AppFonts.bodySmall.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      process.name,
                      style: AppFonts.bodyLarge.copyWith(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: ProcessListColumn.cpu.flex,
              child: Row(
                children: [
                  Text(
                    '${process.cpuUsage.toOneDecimal}%',
                    style: AppFonts.bodyMedium,
                  ),
                  Expanded(
                    child: HorizontalProgressMonitor(
                      value: process.cpuUsage,
                      height: 8,
                      useGradient: false,
                      progressColor: AppColors.selectedColor,
                    ).withPaddingOnly(left: 12, right: 32),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: ProcessListColumn.memory.flex,
              child: Text(
                process.memoryMB.memoryFormatted,
                style: AppFonts.bodyMedium,
              ),
            ),
            Expanded(
              flex: ProcessListColumn.user.flex,
              child: Text(
                process.user,
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ).withPaddingSymmetric(vertical: 12, horizontal: 12),
      ),
    );
  }
}
