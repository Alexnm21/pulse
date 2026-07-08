import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pulse/core/extensions/widgetx.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/app_fonts.dart';
import 'package:pulse/features/processes/domain/enums/process_list_column.dart';

class ProcessListHeader extends StatelessWidget {
  const ProcessListHeader({
    super.key,
    required this.sortBy,
    required this.sortAscending,
    required this.onSort,
  });

  final ProcessListColumn? sortBy;
  final bool sortAscending;
  final void Function(ProcessListColumn column) onSort;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: ProcessListColumn.name.flex,
          child: _SortableHeaderCell(
            label: 'processes.name'.tr(),
            column: ProcessListColumn.name,
            sortBy: sortBy,
            sortAscending: sortAscending,
            onSort: onSort,
          ),
        ),
        Expanded(
          flex: ProcessListColumn.cpu.flex,
          child: _SortableHeaderCell(
            label: 'processes.cpu'.tr(),
            column: ProcessListColumn.cpu,
            sortBy: sortBy,
            sortAscending: sortAscending,
            onSort: onSort,
          ),
        ),
        Expanded(
          flex: ProcessListColumn.memory.flex,
          child: _SortableHeaderCell(
            label: 'processes.memory'.tr(),
            column: ProcessListColumn.memory,
            sortBy: sortBy,
            sortAscending: sortAscending,
            onSort: onSort,
          ),
        ),
        Expanded(
          flex: ProcessListColumn.user.flex,
          child: Text('processes.user'.tr(), style: AppFonts.bodyMedium),
        ),
      ],
    ).withPaddingSymmetric(horizontal: 32, vertical: 12);
  }
}

class _SortableHeaderCell extends StatefulWidget {
  const _SortableHeaderCell({
    required this.label,
    required this.column,
    required this.sortBy,
    required this.sortAscending,
    required this.onSort,
  });

  final String label;
  final ProcessListColumn column;
  final ProcessListColumn? sortBy;
  final bool sortAscending;
  final void Function(ProcessListColumn column) onSort;

  @override
  State<_SortableHeaderCell> createState() => _SortableHeaderCellState();
}

class _SortableHeaderCellState extends State<_SortableHeaderCell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSorted = widget.column == widget.sortBy;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => widget.onSort(widget.column),
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          alignment: Alignment.centerLeft,
          duration: const Duration(milliseconds: 150),
          child: AnimatedOpacity(
            opacity: isSorted || _isHovered ? 1.0 : 0.6,
            duration: const Duration(milliseconds: 150),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: AppFonts.bodyMedium.copyWith(
                    color: isSorted ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    isSorted
                        ? (widget.sortAscending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward)
                        : Icons.unfold_more,
                    size: 14,
                    color: isSorted
                        ? Colors.white
                        : (_isHovered
                              ? AppColors.textSecondary
                              : AppColors.white006),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
