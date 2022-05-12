import '../../sync_validator.dart';
import 'is_before_now_validation_exception.dart';

class IsBeforeNowValidator extends SyncValidator<DateTime> {
  @override
  void onValidateSync(DateTime value) {
    if (!value.isBefore(DateTime.now())) {
      throw IsBeforeNowValidationException(failedValue: value);
    }
  }
}
