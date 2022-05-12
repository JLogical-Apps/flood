import '../../sync_validator.dart';
import 'min_length_validation_exception.dart';

class MinLengthValidator<T> extends SyncValidator<T> {
  final int minLength;

  MinLengthValidator({required this.minLength});

  @override
  void onValidateSync(T value) {
    if (value == null) {
      throw MinLengthValidationException(failedValue: value, minLength: minLength);
    }

    final string = value.toString();
    if (string.length < minLength) {
      throw MinLengthValidationException(failedValue: value, minLength: minLength);
    }
  }
}
