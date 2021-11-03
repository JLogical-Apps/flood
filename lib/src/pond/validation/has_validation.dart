import 'package:jlogical_utils/src/pond/validation/validation_state.dart';

abstract class HasValidation {
  void onValidate();

  ValidationState get validationState;
}