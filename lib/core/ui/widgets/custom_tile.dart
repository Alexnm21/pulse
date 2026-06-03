import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/ui/widgets/svg_icon.dart';

class CustomTile extends StatefulWidget {
  final String icon;
  final String label;
  final Function() onPressed;
  final bool selected;
  const CustomTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.selected,
  });

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
          color: const Color(0xFFADC6FF).withValues(alpha: _getOpacity()),
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

  double _getOpacity() {
    if (widget.selected) return 0.2;
    if (isHover) return 0.1;
    return 0;
  }
}
