part of '../page/main_page.dart';

class _SidebarTile extends StatelessWidget {
  final NavigationItems item;
  const _SidebarTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<MainBloc>().state.selectedItem == item;
    return CustomTile(
      icon: item.icon,
      selected: selected,
      label: 'main.${item.name}'.tr(),
      onPressed: () => context.read<MainBloc>().selectNavigationItem(item),
    );
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(24),
      color: AppColors.sidebarBackground,
      child: Column(
        children: [
          const Text('Pulse', style: AppFonts.h1).withPaddingOnly(bottom: 25),
          ...NavigationItems.values.map((e) => _SidebarTile(item: e)),
        ],
      ),
    );
  }
}
