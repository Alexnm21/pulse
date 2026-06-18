class MemoryEntity {

  const MemoryEntity({
    required this.totalMemory,
    required this.usedMemory,
    required this.appMemory,
    required this.wiredMemory,
    required this.compressedMemory,
  });
  final double totalMemory;
  final double usedMemory;
  final double appMemory;
  final double wiredMemory;
  final double compressedMemory;

  @override
  String toString() {
    return '''MemoryEntity(totalMemory: $totalMemory, appMemory: $appMemory, wiredMemory: $wiredMemory, compressedMemory: $compressedMemory)''';
  }
}
