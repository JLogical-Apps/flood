import 'package:jlogical_utils/src/patterns/validation/validator.dart';
import 'package:jlogical_utils/src/patterns/validation/validators/parsing/is_int_validation_exception.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

class IsIntValidator extends Validator<String?> {
  @override
  void onValidate(String? value) {
    if (value == null || value.isBlank) {
      return;
    }

    final parse = value.tryParseIntAfterClean(cleanCommas: false, cleanCurrency: false);
    if (parse == null) {
      throw IsIntValidationException(validator: this, failedValue: value);
    }
  }
}
