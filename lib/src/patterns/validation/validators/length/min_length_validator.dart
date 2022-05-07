import '../../validator.dart';
import 'min_length_validation_exception.dart';

class MinLengthValidator extends Validator<dynamic> {
  final int minLength;

  MinLengthValidator({required this.minLength});

  @override
  void onValidate(dynamic value) {
    if (value == null) {
      return;
    }

    final string = value.toString();
    if (string.length < minLength) {
      throw MinLengthValidationException(validator: this, failedValue: value);
    }
  }
}
