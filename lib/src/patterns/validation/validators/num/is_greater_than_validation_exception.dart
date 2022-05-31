import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../validation_exception.dart';

class IsGreaterThanValidationException extends ValidationException<num> {
  final num greaterThan;

  IsGreaterThanValidationException({required this.greaterThan, required super.failedValue});

  @override
  String toString() {
    return 'Must be greater than ${greaterThan.formatIntOrDouble()}';
  }
}
