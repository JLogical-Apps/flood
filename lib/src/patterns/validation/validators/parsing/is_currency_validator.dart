import 'package:jlogical_utils/src/patterns/validation/validator.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import 'is_currency_validation_exception.dart';

class IsCurrencyValidator extends Validator<String> {
  @override
  void onValidate(String value) {
    final parse = value.tryParseDoubleAfterClean(cleanCommas: true, cleanCurrency: true);
    if (parse == null) {
      throw IsCurrencyValidationException(validator: this, failedValue: value);
    }
  }
}
