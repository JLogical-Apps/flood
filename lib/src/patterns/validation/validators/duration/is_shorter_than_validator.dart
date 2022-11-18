import 'package:jlogical_utils/src/patterns/validation/validators/duration/is_shorter_than_validation_exception.dart';

import '../../sync_validator.dart';

class IsShorterThanValidator extends SyncValidator<Duration?> {
  final Duration duration;

  IsShorterThanValidator({required this.duration});

  @override
  void onValidateSync(Duration? value) {
    if (value == null) {
      return;
    }
    if (value >= duration) {
      throw IsShorterThanValidationException(failedValue: value, duration: duration);
    }
  }
}
