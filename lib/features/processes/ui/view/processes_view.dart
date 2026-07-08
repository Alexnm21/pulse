import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/dependency_injection/injection_container.dart' as di;
import 'package:pulse/core/extensions/contextx.dart';
import 'package:pulse/core/extensions/widgetx.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/app_fonts.dart';
import 'package:pulse/core/ui/widgets/pulse_alert_dialog.dart';
import 'package:pulse/core/ui/widgets/pulse_button.dart';
import 'package:pulse/features/processes/domain/entities/process_entity.dart';
import 'package:pulse/features/processes/ui/bloc/processes_bloc.dart';
import 'package:pulse/features/processes/ui/widgets/process_list_header.dart';
import 'package:pulse/features/processes/ui/widgets/process_tile.dart';

class ProcessesView extends StatelessWidget {
  const ProcessesView({super.key});

  void _showKillConfirmation(BuildContext context, ProcessEntity process) {
    PulseAlertDialog.show(
      context: context,
      title: 'processes.kill_confirm_title'.tr(),

      content: 'processes.kill_confirm_message'.tr(
        namedArgs: {'name': process.name, 'pid': process.pid.toString()},
      ),
      confirmLabel: 'processes.kill_confirm'.tr(),

      onConfirm: () => context.read<ProcessesBloc>().killProcess(process.pid),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ProcessesBloc>(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(elevation: 1, title: _ProcessSearchBar()),
        body: BlocConsumer<ProcessesBloc, ProcessesState>(
          listenWhen: (previous, current) {
            if (previous is! ProcessesError && current is ProcessesError) {
              return true;
            }
            if (current is ProcessesLoaded && current.killResult != null) {
              return true;
            }
            return false;
          },
          listener: (context, state) {
            if (state is ProcessesError) {
              PulseAlertDialog.show(
                context: context,
                title: 'Error',
                content: state.message,
                confirmLabel: 'OK',
                onConfirm: () => Navigator.of(context).pop(),
                cancelable: false,
              );
            }
            if (state is ProcessesLoaded && state.killResult != null) {
              final (success, message) = state.killResult!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'processes.kill_success'.tr()
                        : 'processes.kill_error'.tr(
                            namedArgs: {'error': message},
                          ),
                  ),
                  backgroundColor: success
                      ? AppColors.selectedColor
                      : AppColors.critical,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProcessesLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Processes',
                        style: AppFonts.h2.copyWith(color: Colors.white),
                      ),
                      if (state.selectedProcess != null)
                        PulseButton(
                          onPressed: () => _showKillConfirmation(
                            context,
                            state.selectedProcess!,
                          ),
                          icon: 'stop',
                          label: 'processes.kill'.tr(),
                          foregroundColor: AppColors.textDark,
                          textStyle: AppFonts.bodySmall,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: state.filteredProcesses.isEmpty
                        ? Center(
                            child: Text(
                              state.searchQuery.isEmpty
                                  ? 'No active processes'
                                  : 'No processes matching "${state.searchQuery}"',
                              style: AppFonts.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: AppColors.transparentCard,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                ProcessListHeader(
                                  sortBy: state.sortBy,
                                  sortAscending: state.sortAscending,
                                  onSort: (column) {
                                    final ascending = column == state.sortBy
                                        ? !state.sortAscending
                                        : true;
                                    context.read<ProcessesBloc>().add(
                                      SortProcessesEvent(
                                        column: column,
                                        ascending: ascending,
                                      ),
                                    );
                                  },
                                ),
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: state.filteredProcesses.length,
                                    separatorBuilder: (_, _) => const Divider(
                                      height: 1,
                                      color: AppColors.white006,
                                    ),
                                    itemBuilder: (context, index) {
                                      final selected =
                                          state.selectedProcess?.pid ==
                                          state.filteredProcesses[index].pid;
                                      return ProcessTile(
                                        process: state.filteredProcesses[index],
                                        selected: selected,
                                        maxMemoryMB: state.maxMemoryMB,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              );
            }

            if (state is ProcessesError) {
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
                      onPressed: () => context.read<ProcessesBloc>().add(
                        const StartProcessesMonitoringEvent(),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ).withPaddingAll(24),
      ),
    );
  }
}

class _ProcessSearchBar extends StatefulWidget {
  @override
  State<_ProcessSearchBar> createState() => _ProcessSearchBarState();
}

class _ProcessSearchBarState extends State<_ProcessSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('main.processes'.tr(), style: AppFonts.h2),
        SizedBox(
          width: context.width / 4,
          child: TextField(
            controller: _controller,
            style: AppFonts.bodyMedium.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search processes...',
              hintStyle: AppFonts.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        _controller.clear();
                        context.read<ProcessesBloc>().add(
                          const SearchProcessesEvent(query: ''),
                        );
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.chipColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              context.read<ProcessesBloc>().add(
                SearchProcessesEvent(query: value),
              );
              setState(() {});
            },
          ),
        ),
      ],
    ).withPaddingSymmetric(horizontal: 24, vertical: 16);
  }
}
