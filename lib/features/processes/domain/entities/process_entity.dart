class ProcessEntity {

  const ProcessEntity({
    required this.name,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.user,
  });
  final String name;
  final double cpuUsage;
  final double memoryUsage;
  final String user;
}
