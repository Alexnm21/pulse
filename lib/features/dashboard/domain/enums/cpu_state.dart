import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';

enum CpuState {
  normal(
    name: 'dashboard.cpu.state.normal',
    color: AppColors.normal,
    range: '5 - 60%',
  ),
  moderately(
    name: 'dashboard.cpu.state.moderately',
    color: AppColors.moderately,
    range: '61 - 85%',
  ),
  critical(
    name: 'dashboard.cpu.state.critical',
    color: AppColors.critical,
    range: '86 - 100%',
  ),
  inactive(
    name: 'dashboard.cpu.state.inactive',
    color: AppColors.unselectedColor,
    range: '< 5%',
  );

  final String name;
  final Color color;
  final String range;

  const CpuState({
    required this.name,
    required this.color,
    required this.range,
  });
}

extension CpuStateX on CpuState {
  static CpuState fromLoad(double load) {
    if (load < 5) {
      return CpuState.inactive;
    } else if (load < 60) {
      return CpuState.normal;
    } else if (load < 85) {
      return CpuState.moderately;
    } else {
      return CpuState.critical;
    }
  }

  String getName() {
    return name.tr();
  }
}
