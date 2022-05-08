import '../../validator.dart';
import 'max_length_validation_exception.dart';

class MaxLengthValidator<T> extends Validator<T> {
  final int maxLength;

  MaxLengthValidator({required this.maxLength});

  @override
  void onValidate(T value) {
    if (value == null) {
      throw MaxLengthValidationException(validator: this, failedValue: value);
    }

    final string = value.toString();
    if (string.length > maxLength) {
      throw MaxLengthValidationException(validator: this, failedValue: value);
    }
  }
}
