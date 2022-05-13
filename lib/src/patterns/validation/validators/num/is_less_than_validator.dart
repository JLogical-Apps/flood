import '../../sync_validator.dart';
import 'is_less_than_validation_exception.dart';

class IsLessThanValidator<N extends num> extends SyncValidator<N?> {
  final N lessThan;

  IsLessThanValidator(this.lessThan);

  @override
  void onValidateSync(N? value) {
    if (value == null) {
      return;
    }

    if (value >= lessThan) {
      throw IsLessThanValidationException(failedValue: value);
    }
  }
}
