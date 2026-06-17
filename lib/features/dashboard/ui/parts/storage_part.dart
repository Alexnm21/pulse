part of '../view/dashboard_view.dart';

class StoragePart extends StatelessWidget {
  final StorageEntity storage;
  const StoragePart({super.key, required this.storage});

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
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: SvgIcon(name: 'storage', color: AppColors.selectedColor),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'dashboard.storage.title'.tr().toUpperCase(),
                style: AppFonts.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${storage.usedStorage.round()} GB / ${storage.totalStorage.round()} GB',
                style: AppFonts.h2,
              ),
            ],
          ).withPaddingOnly(left: 16),
        ],
      ),
    );
  }
}
