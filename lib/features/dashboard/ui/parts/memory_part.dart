part of '../view/dashboard_view.dart';

class MemoryPart extends StatelessWidget {
  final MemoryEntity data;
  const MemoryPart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CrystalCard(
      child: Column(
        children: [
          Row(
            children: [
              SvgIcon(
                name: 'memory',
                color: AppColors.critical,
              ).withPaddingOnly(right: 8),
              Text(
                'dashboard.memory.title'.tr(),
                style: AppFonts.bodyLarge.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 56),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${data.usedMemory.toOneDecimal} GB', style: AppFonts.h1),
              Text(' / ${data.totalMemory} GB'),
            ],
          ).withPaddingOnly(bottom: 4),
          HorizontalProgressMonitor(
            value: (data.usedMemory / data.totalMemory) * 100,
            height: 12,
          ),
          const SizedBox(height: 24),

          MemoryRow(
            color: AppColors.normal,
            text: 'dashboard.memory.app'.tr(),
            value: data.appMemory,
          ),

          MemoryRow(
            color: AppColors.moderately,
            text: 'dashboard.memory.wired'.tr(),
            value: data.wiredMemory,
          ).withPaddingSymmetric(vertical: 12),
          MemoryRow(
            color: AppColors.unselectedColor,
            text: 'dashboard.memory.compressed'.tr(),
            value: data.compressedMemory,
          ),
        ],
      ),
    );
  }
}
