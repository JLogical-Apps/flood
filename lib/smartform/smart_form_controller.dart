import 'cubit/smart_form_cubit.dart';

/// Optional controller for a smart form.
class SmartFormController {
  SmartFormCubit smartFormCubit;

  /// Sets the cubit this controller will be interacting with.
  void setCubit(SmartFormCubit cubit) {
    smartFormCubit = cubit;
  }

  /// Validates the attached SmartForm. Returns whether the validation was successful.
  Future<bool> validate() async {
    return smartFormCubit.validate();
  }
}
