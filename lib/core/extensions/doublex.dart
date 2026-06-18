extension DoubleX on double {
  /// Returns the same double but rounded to one decimal.
  /// Ej: 35.4678 -> 35.5
  double get toOneDecimal => (this * 10).roundToDouble() / 10;
}
