import '../../sync_validator.dart';
import 'is_one_of_validation_exception.dart';

class IsOneOfValidator<T> extends SyncValidator<T> {
  final List<T> options;

  IsOneOfValidator({required this.options});

  @override
  void onValidateSync(T value) {
    if (!options.contains(value)) {
      throw IsOneOfValidationException(validator: this, failedValue: value);
    }
  }
}
