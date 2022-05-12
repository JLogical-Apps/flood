import 'package:jlogical_utils/src/patterns/validation/validators/list/is_one_of_validator.dart';

import '../../validation_exception.dart';

class IsOneOfValidationException<T> extends ValidationException<IsOneOfValidator<T>, T> {
  IsOneOfValidationException({required IsOneOfValidator<T> validator, required failedValue})
      : super(validator: validator, failedValue: failedValue);
}
