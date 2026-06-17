import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String name;
  final double? width;
  final double? height;
  final Color? color;
  const SvgIcon({
    super.key,
    required this.name,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(color ?? Colors.white, BlendMode.srcIn),
    );
  }
}
