part of '../view/dashboard_view.dart';

class TemperaturePart extends StatelessWidget {
  const TemperaturePart({super.key, required this.temperature});
  final List<double> temperature;

  @override
  Widget build(BuildContext context) {
    return CrystalCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.chipColor,
              border: Border.all(color: AppColors.white010),
            ),
            child: const SvgIcon(name: 'temperature', color: AppColors.critical),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'dashboard.temperature.title'.tr().toUpperCase(),
                style: AppFonts.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                temperature.isEmpty ? '0' : '${temperature.last.round()} °C',
                style: AppFonts.h2,
              ),
            ],
          ).withPaddingOnly(left: 16),
          if (temperature.length > 1) const Spacer(),
          if (temperature.length > 1)
            TemperatureSparkline(dataPoints: temperature),
        ],
      ),
    );
  }
}
