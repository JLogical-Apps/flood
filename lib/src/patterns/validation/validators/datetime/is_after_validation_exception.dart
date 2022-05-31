import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../validation_exception.dart';

class IsAfterValidationException extends ValidationException<DateTime> {
  final DateTime after;

  IsAfterValidationException({required this.after, required super.failedValue});

  @override
  String toString() {
    return 'Must be after ${after.formatDate()}';
  }
}
