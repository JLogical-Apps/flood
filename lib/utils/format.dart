import 'package:intl/intl.dart';

/// Extension methods for formatting.
extension NumberFormatUtil on num {
  /// Formats as an int if possible, otherwise as a double.
  String formatIntOrDouble() {
    final format = this.toInt() == this ? NumberFormat('#,###', 'en_US') : NumberFormat('#,###.0', 'en_US');
    return format.format(this.toDouble());
  }

  /// Formats as a currency.
  String formatCurrency() {
    final format = NumberFormat('#,##0.00', 'en_US');
    return '\$${format.format(this.toDouble())}';
  }
}

/// Extension methods for parsing numbers.
extension NumberParseUtil on String {
  /// Parses the string after cleaning up some user inputs.
  double tryParseDoubleAfterClean({bool cleanCommas = true, bool cleanCurrency = true}) {
    String clean = this;
    if (cleanCommas) clean = clean.replaceAll(',', '');
    if (cleanCurrency) clean = clean.replaceAll('\$', '');

    return double.tryParse(clean);
  }

  /// Parses the string after cleaning up some user inputs.
  int tryParseIntAfterClean({bool cleanCommas = true, bool cleanCurrency = true}) {
    String clean = this;
    if (cleanCommas) clean = clean.replaceAll(',', '');
    if (cleanCurrency) clean = clean.replaceAll('\$', '');

    return int.tryParse(clean);
  }
}
