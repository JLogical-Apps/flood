import 'package:jlogical_utils/src/patterns/validation/validators/required/required_validation_exception.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../sync_validator.dart';

class RequiredValidator<C> extends SyncValidator<C> {
  @override
  void onValidateSync(C value) {
    if (value == null) {
      throw RequiredValidationException(failedValue: value);
    }

    if (value == false) {
      throw RequiredValidationException(failedValue: value);
    }

    if (value is String && value.isBlank) {
      throw RequiredValidationException(failedValue: value);
    }

    if (value is Iterable && value.isEmpty) {
      throw RequiredValidationException(failedValue: value);
    }

    if (value is Map && value.isEmpty) {
      throw RequiredValidationException(failedValue: value);
    }
  }
}
