part of '../view/dashboard_view.dart';

class CpuPart extends StatelessWidget {
  final CpuEntity cpu;

  const CpuPart({super.key, required this.cpu});

  @override
  Widget build(BuildContext context) {
    return CrystalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgIcon(
                name: 'cpu',
                color: AppColors.selectedColor,
              ).withPaddingOnly(right: 8),
              Text('dashboard.cpu.title'.tr(), style: AppFonts.bodyLarge),

              Spacer(),
              CpuStateChip(cpuState: CpuStateX.fromLoad(cpu.totalLoad)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            cpu.name,
            style: AppFonts.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressMonitor(
                value: cpu.totalLoad,
                title: 'dashboard.cpu.load'.tr(),
              ),
            ],
          ),
          const Divider().withPaddingOnly(bottom: 16, top: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CpuColumn(title: 'dashboard.cpu.user'.tr(), value: cpu.user),
              _CpuColumn(title: 'dashboard.cpu.system'.tr(), value: cpu.system),
              _CpuColumn(title: 'dashboard.cpu.idle'.tr(), value: cpu.idle),
              const SizedBox(width: 32),
            ],
          ),
          const Divider().withPaddingOnly(bottom: 16, top: 24),
          _CpuStateLegend(),
        ],
      ),
    );
  }
}

class _CpuColumn extends StatelessWidget {
  final String title;
  final double value;
  const _CpuColumn({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title.toUpperCase(),
          style: AppFonts.bodyMedium.copyWith(color: AppColors.unselectedColor),
        ).withPaddingOnly(bottom: 4),
        Text(
          '${value.toOneDecimal}%',
          style: AppFonts.bodyMedium.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class _CpuStateLegend extends StatelessWidget {
  const _CpuStateLegend();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'dashboard.cpu.state.load_state'.tr(),
          style: AppFonts.bodyMedium.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...CpuState.values.map(
              (e) => Row(
                children: [
                  CircleAvatar(radius: 6, backgroundColor: e.color),
                  Text(
                    e.displayName(context),
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.bodyMedium.copyWith(color: Colors.white),
                  ).withPaddingSymmetric(horizontal: 8),
                  Text(
                    e.range,
                    style: AppFonts.bodyMedium.copyWith(
                      color: AppColors.unselectedColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
