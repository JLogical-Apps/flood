import 'package:jlogical_utils/src/patterns/validation/validator.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import 'is_email_validation_exception.dart';

class IsEmailValidator extends Validator<String?> {
  @override
  void onValidate(String? value) {
    if (value == null || value.isBlank) {
      return;
    }

    if (!value.isEmail) {
      throw IsEmailValidationException(validator: this, failedValue: value);
    }
  }
}
