import '../../../export_core.dart';
import '../../sync_validator.dart';
import 'is_greater_than_validation_exception.dart';

class IsGreaterThanValidator<N extends num> extends SyncValidator<N?> {
  final N greaterThan;

  IsGreaterThanValidator(this.greaterThan);

  @override
  void onValidateSync(N? value) {
    if (value == null) {
      return;
    }

    if (value <= greaterThan) {
      throw IsGreaterThanValidationException(failedValue: value, greaterThan: greaterThan);
    }
  }
}
