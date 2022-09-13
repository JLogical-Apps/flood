import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../sync_validator.dart';
import 'is_phone_validation_exception.dart';

class IsPhoneValidator extends SyncValidator<String?> {
  @override
  void onValidateSync(String? value) {
    if (value == null) {
      return;
    }

    if (!value.isPhoneNumber) {
      throw IsPhoneValidationException(failedValue: value);
    }
  }
}
