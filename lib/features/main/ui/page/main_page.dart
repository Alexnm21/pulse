import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/domain/enums/navigation_items.dart';
import 'package:pulse/core/extensions/widgetx.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/app_fonts.dart';
import 'package:pulse/core/ui/widgets/custom_tile.dart';
import 'package:pulse/core/ui/widgets/pulse_scaffold.dart';
import 'package:pulse/features/main/ui/bloc/main_bloc.dart';

part '../parts/sidebar.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PulseScaffold(
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return Row(
            children: [
              const Sidebar(),
              Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Builder(
                      key: ValueKey(state.selectedItem),
                      builder: state.selectedItem.viewBuilder,
                    ),
                  ),
              ),
            ],
          );
        },
      ),
    );
  }
}
