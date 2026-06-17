import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/features/dashboard/domain/enums/cpu_state.dart';

extension CpuStateUi on CpuState {
  Color get color => switch (this) {
    CpuState.normal => AppColors.normal,
    CpuState.moderately => AppColors.moderately,
    CpuState.critical => AppColors.critical,
    CpuState.inactive => AppColors.unselectedColor,
  };

  String displayName(BuildContext context) => name.tr();
}
