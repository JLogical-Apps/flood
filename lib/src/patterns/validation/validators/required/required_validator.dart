import 'package:jlogical_utils/src/patterns/validation/validators/required/required_validation_exception.dart';

import '../../validator.dart';

class RequiredValidator<C> extends Validator<C> {
  void onValidate(C value) {
    if (value == null) {
      throw RequiredValidationException(validator: this, failedValue: value);
    }
  }
}
