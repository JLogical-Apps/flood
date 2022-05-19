extension DoubleExtensions on double {
  bool isApproximatelyEqualTo(double other, {double varianceAllowed: 0.001}) {
    return (this - other).abs() <= varianceAllowed;
  }
}
