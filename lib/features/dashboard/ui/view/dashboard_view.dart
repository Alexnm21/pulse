import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/dependency_injection/injection_container.dart';
import 'package:pulse/core/extensions/doublex.dart';
import 'package:pulse/core/extensions/widgetx.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/app_fonts.dart';
import 'package:pulse/core/ui/widgets/circular_progress_monitor.dart';
import 'package:pulse/core/ui/widgets/crystal_card.dart';
import 'package:pulse/core/ui/widgets/horizontal_progress_monitor.dart';
import 'package:pulse/core/ui/widgets/svg_icon.dart';
import 'package:pulse/features/dashboard/domain/entities/cpu_entity.dart';
import 'package:pulse/features/dashboard/domain/entities/memory_entity.dart';
import 'package:pulse/features/dashboard/domain/enums/cpu_state.dart';
import 'package:pulse/features/dashboard/ui/bloc/dashboard_bloc.dart';
import 'package:pulse/features/dashboard/ui/widgets/cpu_state_chip.dart';
import 'package:pulse/features/dashboard/ui/widgets/memory_row.dart';

part '../parts/cpu_part.dart';
part '../parts/memory_part.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>(),
      child: Builder(
        builder: (_) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoaded) {
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 65, child: CpuPart(cpu: state.cpu)),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 35,
                              child: MemoryPart(data: state.memory),
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ).withPaddingAll(24),
          );
        },
      ),
    );
  }
}
