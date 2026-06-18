import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/ui/widgets/svg_icon.dart';

class CustomTile extends StatefulWidget {
  const CustomTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.selected,
  });
  final String icon;
  final String label;
  final Function() onPressed;
  final bool selected;

  @override
  State<CustomTile> createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.selected
              ? AppColors.selectedColor020
              : isHover
                  ? AppColors.selectedColor010
                  : Colors.transparent,
        ),
        child: ListTile(
          onTap: widget.onPressed,
          selected: widget.selected,
          leading: SvgIcon(
            name: widget.icon,
            color: widget.selected
                ? AppColors.selectedColor
                : AppColors.unselectedColor,
          ),
          title: Text(widget.label),
        ),
      ),
    );
  }
}
