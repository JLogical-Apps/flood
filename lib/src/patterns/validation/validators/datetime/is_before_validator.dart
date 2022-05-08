import '../../validator.dart';
import 'is_before_validation_exception.dart';

class IsBeforeValidator extends Validator<DateTime?> {
  final DateTime before;

  IsBeforeValidator({required this.before});

  @override
  void onValidate(DateTime? value) {
    if (value == null) {
      return;
    }

    if (!value.isBefore(before)) {
      throw IsBeforeValidationException(validator: this, failedValue: value);
    }
  }
}
