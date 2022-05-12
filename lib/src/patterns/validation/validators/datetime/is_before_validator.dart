import '../../sync_validator.dart';
import 'is_before_validation_exception.dart';

class IsBeforeValidator extends SyncValidator<DateTime> {
  final DateTime before;

  IsBeforeValidator({required this.before});

  @override
  void onValidateSync(DateTime value) {
    if (!value.isBefore(before)) {
      throw IsBeforeValidationException(failedValue: value);
    }
  }
}
