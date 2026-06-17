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
import 'package:pulse/features/dashboard/domain/entities/storage_entity.dart';
import 'package:pulse/features/dashboard/domain/enums/cpu_state.dart';
import 'package:pulse/features/dashboard/ui/bloc/dashboard_bloc.dart';
import 'package:pulse/features/dashboard/ui/extensions/cpu_state_ext.dart';
import 'package:pulse/features/dashboard/ui/widgets/cpu_state_chip.dart';
import 'package:pulse/features/dashboard/ui/widgets/memory_row.dart';
import 'package:pulse/features/dashboard/ui/widgets/temperature_sparkline.dart';

part '../parts/cpu_part.dart';
part '../parts/memory_part.dart';
part '../parts/storage_part.dart';
part '../parts/temperature_part.dart';

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
              child: BlocConsumer<DashboardBloc, DashboardState>(
                listenWhen: (previous, current) =>
                    previous is! DashboardError && current is DashboardError,
                listener: (context, state) {
                  if (state is DashboardError) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: Text(state.message),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is DashboardLoaded) {
                    return Column(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 65,
                                child: CpuPart(cpu: state.cpu),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 35,
                                child: MemoryPart(data: state.memory),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              flex: 65,
                              child: TemperaturePart(
                                temperature: state.temperature,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 35,
                              child: StoragePart(storage: state.storage),
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  if (state is DashboardError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.message,
                            style: AppFonts.bodyMedium.copyWith(
                              color: AppColors.critical,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () =>
                                context.read<DashboardBloc>().add(
                                      StartCpuMonitoringEvent(),
                                    ),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
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
