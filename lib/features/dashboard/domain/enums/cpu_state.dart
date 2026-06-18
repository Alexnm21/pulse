enum CpuState {
  normal(name: 'dashboard.cpu.state.normal', range: '5 - 60%'),
  moderately(name: 'dashboard.cpu.state.moderately', range: '61 - 85%'),
  critical(name: 'dashboard.cpu.state.critical', range: '86 - 100%'),
  inactive(name: 'dashboard.cpu.state.inactive', range: '< 5%');

  const CpuState({
    required this.name,
    required this.range,
  });

  final String name;
  final String range;
}

extension CpuStateX on CpuState {
  static CpuState fromLoad(double load) {
    if (load < 5) {
      return CpuState.inactive;
    } else if (load < 60) {
      return CpuState.normal;
    } else if (load < 85) {
      return CpuState.moderately;
    } else {
      return CpuState.critical;
    }
  }
}
