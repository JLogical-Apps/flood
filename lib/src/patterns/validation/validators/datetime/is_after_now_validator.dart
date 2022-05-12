import '../../sync_validator.dart';
import 'is_after_now_validation_exception.dart';

class IsAfterNowValidator extends SyncValidator<DateTime> {
  @override
  void onValidateSync(DateTime value) {
    if (!value.isAfter(DateTime.now())) {
      throw IsAfterNowValidationException(failedValue: value);
    }
  }
}
