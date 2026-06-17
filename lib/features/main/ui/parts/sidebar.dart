part of '../page/main_page.dart';

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
          Text('Pulse', style: AppFonts.h1).withPaddingOnly(bottom: 25),
          ...NavigationItems.values.map((e) {
            final selected = e == context.watch<MainBloc>().state.selectedItem;
            return CustomTile(
              icon: e.icon,
              selected: selected,
              label: 'main.${e.name}'.tr(),
              onPressed: () {
                context.read<MainBloc>().selectNavigationItem(e);
              },
            );
          }),
        ],
      ),
    );
  }
}
