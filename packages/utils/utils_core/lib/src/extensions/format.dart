import 'package:filesize/filesize.dart';
import 'package:intl/intl.dart';

/// Extension methods for formatting.
extension NumberFormatUtil on num {
  /// Formats as an int if possible, otherwise as a double.
  String formatIntOrDouble() {
    final format = toInt() == this ? NumberFormat('#,##0', 'en_US') : NumberFormat.decimalPattern('en_US');
    return format.format(toDouble());
  }

  /// Formats as a currency.
  String formatCurrency() {
    final format = NumberFormat('#,##0.00', 'en_US');
    if (this < 0) {
      return '-\$${format.format(toDouble().abs())}';
    } else {
      return '\$${format.format(toDouble())}';
    }
  }
}

extension IntFormatUtil on int {
  /// Formats this amount of cents as currency.
  String formatCentsAsCurrency() {
    return (this / 100).formatCurrency();
  }

  String formatCentsAsCurrencySigned() {
    if (this >= 0) {
      return '+${formatCentsAsCurrency()}';
    } else {
      return formatCentsAsCurrency();
    }
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
  String formatWith(DateFormat Function(DateFormat dateFormat) dateFormatGetter) {
    final dateFormat = dateFormatGetter(DateFormat());
    return dateFormat.format(this);
  }

  String format({bool showDate = true, bool showTime = true}) {
    var dateFormat = DateFormat();
    if (showDate) {
      dateFormat = dateFormat.add_yMd();
    }
    if (showTime) {
      dateFormat = dateFormat.add_jms();
    }
    return dateFormat.format(this);
  }
}
