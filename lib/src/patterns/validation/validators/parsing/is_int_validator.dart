import 'package:jlogical_utils/src/patterns/validation/validators/parsing/is_int_validation_exception.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../sync_validator.dart';

class IsIntValidator extends SyncValidator<String?> {
  @override
  void onValidateSync(String? value) {
    if (value == null) {
      return;
    }

    final parse = value.tryParseIntAfterClean(cleanCommas: false, cleanCurrency: false);
    if (parse == null) {
      throw IsIntValidationException(failedValue: value);
    }
  }
}
