import 'package:flutter/material.dart';
import 'package:pulse/core/extensions/widgetx.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/app_fonts.dart';
import 'package:pulse/core/ui/widgets/svg_icon.dart';

class PulseButton extends StatefulWidget {
  const PulseButton({
    required this.onPressed,
    required this.label,
    this.textStyle = AppFonts.bodySmall,
    this.icon = '',
    this.color = AppColors.selectedColor,
    this.foregroundColor = Colors.white,

    super.key,
  });

  final String label;
  final String icon;
  final Color color;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final TextStyle textStyle;

  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : (_isHovered ? 1.03 : 1.0),
        duration: const Duration(milliseconds: 100),
        child: GestureDetector(
          onTapDown: (event) => setState(() => _isPressed = true),
          onTapUp: (event) {
            setState(() => _isPressed = false);
            widget.onPressed();
          },
          onTapCancel: () => setState(() => _isPressed = false),

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _isHovered
                  ? (Color.lerp(widget.color, Colors.white, 0.15) ??
                        widget.color)
                  : widget.color,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],

              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (widget.icon.isNotEmpty)
                  SvgIcon(
                    name: widget.icon,
                    color: widget.foregroundColor,
                  ).withPaddingOnly(right: 8),
                Text(
                  widget.label,
                  style: widget.textStyle.copyWith(
                    color: widget.foregroundColor,
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
