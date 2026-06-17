import 'package:flutter/material.dart';
import 'package:pulse/features/cleaner/ui/view/cleaner_view.dart';
import 'package:pulse/features/dashboard/ui/view/dashboard_view.dart';
import 'package:pulse/features/processes/ui/view/processes_view.dart';
import 'package:pulse/features/thermal/ui/view/thermal_view.dart';

enum NavigationItems {
  dashboard(
    icon: 'dashboard',
    label: 'main.dashboard',
    viewBuilder: _dashboardBuilder,
  ),
  processes(
    icon: 'processes',
    label: 'main.processes',
    viewBuilder: _processesBuilder,
  ),
  thermal(
    icon: 'thermal',
    label: 'main.thermal',
    viewBuilder: _thermalBuilder,
  ),
  cleaner(
    icon: 'cleaner',
    label: 'main.cleaner',
    viewBuilder: _cleanerBuilder,
  );

  final String icon;
  final String label;
  final WidgetBuilder viewBuilder;

  const NavigationItems({
    required this.icon,
    required this.label,
    required this.viewBuilder,
  });
}

Widget _dashboardBuilder(BuildContext context) => const DashboardView();
Widget _processesBuilder(BuildContext context) => const ProcessesView();
Widget _thermalBuilder(BuildContext context) => const ThermalView();
Widget _cleanerBuilder(BuildContext context) => const CleanerView();
