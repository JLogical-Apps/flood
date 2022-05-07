import '../../validator.dart';
import 'max_length_validation_exception.dart';

class MaxLengthValidator extends Validator<dynamic> {
  final int maxLength;

  MaxLengthValidator({required this.maxLength});

  @override
  void onValidate(dynamic value) {
    if (value == null) {
      return;
    }

    final string = value.toString();
    if (string.length > maxLength) {
      throw MaxLengthValidationException(validator: this, failedValue: value);
    }
  }
}
