import 'package:meta/meta.dart';

import 'cubit/smart_form_cubit.dart';

/// Optional controller for a smart form.
class SmartFormController {
  final SmartFormCubit _smartFormCubit;

  const SmartFormController({@required SmartFormCubit smartFormCubit}) : _smartFormCubit = smartFormCubit;

  /// Whether the smart form is loading.
  bool get isLoading => _smartFormCubit.state.isLoading;

  /// Validates the attached SmartForm. Returns whether the validation was successful.
  Future<bool> validate() async {
    return _smartFormCubit.validate();
  }
}
