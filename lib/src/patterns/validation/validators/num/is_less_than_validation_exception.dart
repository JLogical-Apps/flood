import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../validation_exception.dart';

class IsLessThanValidationException extends ValidationException<num> {

  final num lessThan;

  IsLessThanValidationException({required super.failedValue, required this.lessThan});

  @override
  String toString() {
    return 'Must be less than ${lessThan.formatIntOrDouble()}';
  }
}
