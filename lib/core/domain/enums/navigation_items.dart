import 'package:flutter/material.dart';
import 'package:pulse/features/cleaner/ui/view/cleaner_view.dart';
import 'package:pulse/features/dashboard/ui/view/dashboard_view.dart';
import 'package:pulse/features/processes/ui/view/processes_view.dart';
import 'package:pulse/features/thermal/ui/view/thermal_view.dart';

enum NavigationItems {
  dashboard(icon: 'dashboard', label: 'main.dashboard', view: DashboardView()),
  processes(icon: 'processes', label: 'main.processes', view: ProcessesView()),
  thermal(icon: 'thermal', label: 'main.thermal', view: ThermalView()),
  cleaner(icon: 'cleaner', label: 'main.cleaner', view: CleanerView());

  final String icon;
  final String label;
  final Widget view;
  const NavigationItems({
    required this.icon,
    required this.label,
    required this.view,
  });
}
