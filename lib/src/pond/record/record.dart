import 'package:jlogical_utils/src/pond/validation/validation_state.dart';

import '../../patterns/export_core.dart';
import '../state/stateful.dart';

abstract class Record with SyncValidator<void> implements Stateful, Validator<void> {
  ValidationState validationState = ValidationState.unvalidated;

  void validateRecord();

  @override
  void onValidateSync(_) {
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
