import 'package:jlogical_utils/src/patterns/validation/validators/required/required_validation_exception.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../validator.dart';

class RequiredValidator<C> extends Validator<C> {
  void onValidate(C value) {
    if (value == null) {
      throw RequiredValidationException(validator: this, failedValue: value);
    }

    if (value == false) {
      throw RequiredValidationException(validator: this, failedValue: value);
    }

    if (value is String && value.isBlank) {
      throw RequiredValidationException(validator: this, failedValue: value);
    }

    if (value is Iterable && value.isEmpty) {
      throw RequiredValidationException(validator: this, failedValue: value);
    }
  }
}
