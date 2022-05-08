import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../sync_validator.dart';
import 'is_double_validation_exception.dart';

class IsDoubleValidator extends SyncValidator<String> {
  @override
  void onValidateSync(String value) {
    final parse = value.tryParseDoubleAfterClean(cleanCommas: false, cleanCurrency: false);
    if (parse == null) {
      throw IsDoubleValidationException(validator: this, failedValue: value);
    }
  }
}
