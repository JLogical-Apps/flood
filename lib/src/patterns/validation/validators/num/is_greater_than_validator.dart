import '../../sync_validator.dart';
import 'is_greater_than_validation_exception.dart';

class IsGreaterThanValidator extends SyncValidator<num> {
  final num greaterThan;

  IsGreaterThanValidator(this.greaterThan);

  @override
  void onValidateSync(num value) {
    if (value <= greaterThan) {
      throw IsGreaterThanValidationException(failedValue: value);
    }
  }
}
