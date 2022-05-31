import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../validation_exception.dart';

class IsBeforeValidationException extends ValidationException<DateTime> {
  final DateTime before;

  IsBeforeValidationException({required this.before, required super.failedValue});

  @override
  String toString() {
    return 'Must be before ${before.formatDate()}!';
  }
}
