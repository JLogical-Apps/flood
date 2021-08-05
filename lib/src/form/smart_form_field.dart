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

  /// Whether the form is enabled.
  /// If not enabled, FormFields should not allow user input or validation.
  final bool enabled;

  const SmartFormField({
    Key? key,
    required this.name,
    required this.initialValue,
    this.validators: const [],
    this.enabled: true,
  }) : super(key: key);

  /// Builds the form given the [value] and [error].
  Widget buildForm(BuildContext context, T value, String? error, bool enabled, SmartFormController smartFormController);

  @override
  Widget build(BuildContext context) {
    var smartFormController = context.select((SmartFormController value) => value);

    useOneTimeEffect(() {
      smartFormController.registerFormField(
        name: name,
        initialValue: initialValue,
        enabled: enabled,
        validators: validators,
      );
    });

    // Update the enabled property in the controller every time this field's [enabled] changes.
    useEffect(() {
      smartFormController.setEnabled(name: name, enabled: enabled);
    }, [enabled]);

    // Set [enabled] to false when the field is disposed.
    useOneTimeEffect(() {
      return () => smartFormController.setEnabled(name: name, enabled: false);
    });

    var smartFormData = useComputed(() => smartFormController.getFormDataX(name)).value;

    return buildForm(context, smartFormData.value, smartFormData.error, enabled, smartFormController);
  }
}
