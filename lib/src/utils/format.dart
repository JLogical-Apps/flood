import 'package:intl/intl.dart';
import 'package:filesize/filesize.dart';

/// Extension methods for formatting.
extension NumberFormatUtil on num {
  /// Formats as an int if possible, otherwise as a double.
  String formatIntOrDouble() {
    final format = this.toInt() == this ? NumberFormat('#,##0', 'en_US') : NumberFormat.decimalPattern('en_US');
    return format.format(this.toDouble());
  }

  /// Formats as a currency.
  String formatCurrency() {
    final format = NumberFormat('#,##0.00', 'en_US');
    if (this < 0) {
      return '-\$${format.format(this.toDouble().abs())}';
    } else {
      return '\$${format.format(this.toDouble())}';
    }
  }
}

extension IntFormatUtil on int {
  /// Formats this amount of cents as currency.
  String formatCentsAsCurrency() {
    return (this / 100).formatCurrency();
  }

  /// Formats this amount of bytes as a label.
  /// For example, '4900' would be 4.9 GB
  String formatBytesToLabel() {
    return filesize(this);
  }
}

/// Extension methods for parsing numbers.
extension NumberParseUtil on String {
  /// Parses the string after cleaning up some user inputs.
  double? tryParseDoubleAfterClean({bool cleanCommas = true, bool cleanCurrency = true}) {
    String clean = this;
    if (cleanCommas) clean = clean.replaceAll(',', '');
    if (cleanCurrency) clean = clean.replaceAll('\$', '');

    return double.tryParse(clean);
  }

  /// Parses the string after cleaning up some user inputs.
  int? tryParseIntAfterClean({bool cleanCommas = true, bool cleanCurrency = true}) {
    String clean = this;
    if (cleanCommas) clean = clean.replaceAll(',', '');
    if (cleanCurrency) clean = clean.replaceAll('\$', '');

    return int.tryParse(clean);
  }
}

/// Extension methods for formatting DateTimes.
extension DateFormatUtil on DateTime {
  /// Formats to include both date and time.
  String formatDateTime({bool isLong = true, bool includeSeconds = false}) {
    DateFormat dateFormat = isLong ? DateFormat.yMMMMd() : DateFormat.yMd();
    dateFormat = includeSeconds ? dateFormat.add_jms() : dateFormat.add_jm();

    return dateFormat.format(this);
  }

  /// Formats to include only date.
  String formatDate({bool isLong = true}) {
    if (isLong) {
      return DateFormat.yMMMMd().format(this);
    } else {
      return DateFormat.yMd().format(this);
    }
  }

  /// Formats to include only time.
  String formatTime() {
    return DateFormat.jm().format(this);
  }
}
