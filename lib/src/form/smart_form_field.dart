import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/form/validation/validation.dart';
import 'package:provider/provider.dart';

import 'smart_form_controller.dart';

/// A widget to placed in a SmartForm that handles data changes and form validation.
abstract class SmartFormField<T> extends HookWidget {
  /// The name to reference the field by.
  final String name;

  /// The initial value of the field.
  final T initialValue;

  /// The validators that validate the field.
  final List<Validation<T>> validators;

  const SmartFormField({Key? key, required this.name, required this.initialValue, this.validators: const []}) : super(key: key);

  /// Builds the form given the [value] and [error].
  Widget buildForm(BuildContext context, T value, String? error, SmartFormController smartFormController);

  @override
  Widget build(BuildContext context) {
    var smartFormController = context.select((SmartFormController value) => value);

    useOneTimeEffect(() {
      smartFormController.registerFormField(name: name, initialValue: initialValue, validators: validators);
    });

    var smartFormData = useComputed(() => smartFormController.getFormDataX(name)).value;

    return buildForm(context, smartFormData.value, smartFormData.error, smartFormController);
  }
}
