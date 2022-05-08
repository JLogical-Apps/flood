import 'package:jlogical_utils/src/patterns/validation/validator.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import 'is_double_validation_exception.dart';

class IsDoubleValidator extends Validator<String> {
  @override
  void onValidate(String value) {
    final parse = value.tryParseDoubleAfterClean(cleanCommas: false, cleanCurrency: false);
    if (parse == null) {
      throw IsDoubleValidationException(validator: this, failedValue: value);
    }
  }
}
