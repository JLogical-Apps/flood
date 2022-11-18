import 'package:jlogical_utils/src/patterns/validation/validators/duration/is_longer_than_validation_exception.dart';

import '../../sync_validator.dart';

class IsLongerThanValidator extends SyncValidator<Duration?> {
  final Duration duration;

  IsLongerThanValidator({required this.duration});

  @override
  void onValidateSync(Duration? value) {
    if (value == null) {
      return;
    }
    if (value <= duration) {
      throw IsLongerThanValidationException(failedValue: value, duration: duration);
    }
  }
}
