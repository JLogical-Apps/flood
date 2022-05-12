import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../sync_validator.dart';
import 'is_email_validation_exception.dart';

class IsEmailValidator extends SyncValidator<String> {
  @override
  void onValidateSync(String value) {
    if (!value.isEmail) {
      throw IsEmailValidationException(failedValue: value);
    }
  }
}
