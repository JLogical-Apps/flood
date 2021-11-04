import 'package:jlogical_utils/src/pond/export.dart';

class ValidationException {
  final Validator failedValidator;
  final String errorMessage;

  const ValidationException({required this.failedValidator, required this.errorMessage});

  @override
  String toString() {
    return 'Validation exception when validating $failedValidator:\n$errorMessage';
  }
}
