import 'cubit/smart_form_cubit.dart';

/// Optional controller for a smart form.
class SmartFormController {
  late SmartFormCubit _smartFormCubit;

  SmartFormController();

  /// Whether the smart form is loading.
  bool get isLoading => _smartFormCubit.state.isLoading;

  /// Sets the cubit of the controller.
  void setCubit(SmartFormCubit smartFormCubit) {
    _smartFormCubit = smartFormCubit;
  }

  /// Validates the attached SmartForm. Returns whether the validation was successful.
  Future<bool> validate() async {
    return _smartFormCubit.validate();
  }

  /// Returns the value of the field with [name].
  dynamic getValue(String name) {
    return _smartFormCubit.getValue(name);
  }
}
