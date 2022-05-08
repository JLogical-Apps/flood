import '../../validator.dart';
import 'is_after_validation_exception.dart';

class IsAfterValidator extends Validator<DateTime?> {
  final DateTime after;

  IsAfterValidator({required this.after});

  @override
  void onValidate(DateTime? value) {
    if (value == null) {
      return;
    }

    if (!value.isAfter(after)) {
      throw IsAfterValidationException(validator: this, failedValue: value);
    }
  }
}
