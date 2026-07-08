extension DoubleX on double {
  /// Returns the same double but rounded to one decimal.
  /// Ej: 35.4678 -> 35.5
  double get toOneDecimal => (this * 10).roundToDouble() / 10;

  /// Formats a memory value in MB to a human-readable string.
  /// Shows GB with one decimal if >= 1000 MB, otherwise MB.
  /// Ej: 512.0 -> "512.0 MB", 2048.0 -> "2.0 GB"
  String get memoryFormatted {
    if (this >= 1000) {
      return '${(this / 1024).toOneDecimal} GB';
    }
    return '$toOneDecimal MB';
  }
}
