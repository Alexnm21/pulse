extension DoubleX on double {
  /// Returns the same double but rounded to one decimal.
  /// Ej: 35.4678 -> 35.5
  double get toOneDecimal {
    return double.parse(toStringAsFixed(1));
  }
}
