import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/dependency_injection/injection_container.dart' as di;
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/app_fonts.dart';
import 'package:pulse/features/processes/ui/bloc/processes_bloc.dart';
import 'package:pulse/features/processes/ui/widgets/process_tile.dart';

class ProcessesView extends StatelessWidget {
  const ProcessesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ProcessesBloc>(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: _ProcessSearchBar(),
        ),
        body: BlocConsumer<ProcessesBloc, ProcessesState>(
          listenWhen: (previous, current) =>
              previous is! ProcessesError && current is ProcessesError,
          listener: (context, state) {
            if (state is ProcessesError) {
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
            if (state is ProcessesLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 24, bottom: 16),
                    child: Text(
                      'Active Processes',
                      style: AppFonts.h1.copyWith(color: Colors.white),
                    ),
                  ),
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
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: state.filteredProcesses.length,
                            separatorBuilder: (_, _) => const Divider(
                              height: 1,
                              color: AppColors.white006,
                            ),
                            itemBuilder: (context, index) {
                              return ProcessTile(
                                process: state.filteredProcesses[index],
                              );
                            },
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
                      onPressed: () =>
                          context.read<ProcessesBloc>().add(
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
        ),
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
    return TextField(
      controller: _controller,
      style: AppFonts.bodyMedium.copyWith(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search processes...',
        hintStyle: AppFonts.bodyMedium.copyWith(color: AppColors.textSecondary),
        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                onPressed: () {
                  _controller.clear();
                  context.read<ProcessesBloc>().add(const SearchProcessesEvent(query: ''));
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
        context.read<ProcessesBloc>().add(SearchProcessesEvent(query: value));
        setState(() {});
      },
    );
  }
}
