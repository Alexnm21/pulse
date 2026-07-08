import 'package:flutter/material.dart';
import 'package:pulse/core/extensions/widgetx.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/app_fonts.dart';
import 'package:pulse/core/ui/widgets/pulse_button.dart';
import 'package:pulse/core/ui/widgets/svg_icon.dart';

class PulseAlertDialog {
  PulseAlertDialog._();

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmLabel,
    required VoidCallback onConfirm,
    bool cancelable = true,
    bool dismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: dismissible,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.cardBackground,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: 445,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const SvgIcon(
                      name: 'warning',
                      color: AppColors.warning,
                    ),
                  ),
                  Text(title, style: AppFonts.h2.copyWith(color: Colors.white)),
                ],
              ).withPaddingOnly(left: 24, right: 24, top: 24),

              Text(
                content,
                style: AppFonts.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).withPaddingOnly(top: 8, bottom: 16, left: 24, right: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                color: Colors.black.withValues(alpha: 0.2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PulseButton(
                      label: 'Cancel',
                      color: Colors.transparent,
                      foregroundColor: AppColors.unselectedColor,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    const SizedBox(width: 12),
                    PulseButton(
                      label: confirmLabel,
                      color: AppColors.warning,
                      foregroundColor: AppColors.textWarning,
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onConfirm.call();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
