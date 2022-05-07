import 'validator.dart';

abstract class ValidationException<TValidator extends Validator<V>, V> {
  final TValidator validator;
  final V failedValue;

  ValidationException({required this.validator, required this.failedValue});
}
