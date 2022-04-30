import 'package:jlogical_utils/src/pond/validation/validation_state.dart';

import '../state/stateful.dart';
import '../validation/validator.dart';

abstract class Record implements Stateful, Validator {
  ValidationState validationState = ValidationState.unvalidated;

  void validateRecord();

  void validate() {
    try {
      validateRecord();
      validationState = ValidationState.validated;
    } catch (e) {
      validationState = ValidationState.failed;
      throw e;
    }
  }

  void copyFrom(Stateful stateful) {
    state = stateful.state;
  }
}
