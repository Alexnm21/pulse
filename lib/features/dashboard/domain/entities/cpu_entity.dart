class CpuEntity {
  final String name;
  final double totalLoad;
  final double user;
  final double system;
  final double idle;

  const CpuEntity({
    required this.name,
    required this.totalLoad,
    required this.user,
    required this.system,
    required this.idle,
  });
}
