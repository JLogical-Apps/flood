import '../../validator.dart';
import 'min_length_validation_exception.dart';

class MinLengthValidator<T> extends Validator<T> {
  final int minLength;

  MinLengthValidator({required this.minLength});

  @override
  void onValidate(T value) {
    if (value == null) {
      throw MinLengthValidationException(validator: this, failedValue: value);
    }

    final string = value.toString();
    if (string.length < minLength) {
      throw MinLengthValidationException(validator: this, failedValue: value);
    }
  }
}
