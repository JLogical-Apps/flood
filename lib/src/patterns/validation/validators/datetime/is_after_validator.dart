import '../../sync_validator.dart';
import 'is_after_validation_exception.dart';

class IsAfterValidator extends SyncValidator<DateTime?> {
  final DateTime after;

  IsAfterValidator({required this.after});

  @override
  void onValidateSync(DateTime? value) {
    if (value == null) {
      return;
    }
    if (!value.isAfter(after)) {
      throw IsAfterValidationException(failedValue: value);
    }
  }
}
