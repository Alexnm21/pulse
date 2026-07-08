class ProcessEntity {

  const ProcessEntity({
    required this.pid,
    required this.name,
    required this.cpuUsage,
    required this.memoryMB,
    required this.user,
  });
  final int pid;
  final String name;
  final double cpuUsage;
  final double memoryMB;
  final String user;
}
