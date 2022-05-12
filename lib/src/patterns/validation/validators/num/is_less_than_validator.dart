import '../../sync_validator.dart';
import 'is_less_than_validation_exception.dart';

class IsLessThanValidator extends SyncValidator<num> {
  final num lessThan;

  IsLessThanValidator(this.lessThan);

  @override
  void onValidateSync(num value) {
    if (value >= lessThan) {
      throw IsLessThanValidationException(failedValue: value);
    }
  }
}
