import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../sync_validator.dart';
import 'is_currency_validation_exception.dart';

class IsCurrencyValidator extends SyncValidator<String> {
  @override
  void onValidateSync(String value) {
    final parse = value.tryParseDoubleAfterClean(cleanCommas: true, cleanCurrency: true);
    if (parse == null) {
      throw IsCurrencyValidationException(validator: this, failedValue: value);
    }
  }
}
