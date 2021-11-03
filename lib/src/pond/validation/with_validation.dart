import 'package:jlogical_utils/src/pond/validation/validation_state.dart';

mixin WithValidation {
  ValidationState validationState = ValidationState.unvalidated;

  void onValidate();

  void validate() {
    try {
      onValidate();
      validationState = ValidationState.validated;
    } on Exception catch (e) {
      validationState = ValidationState.failed;
      throw e;
    }
  }
}