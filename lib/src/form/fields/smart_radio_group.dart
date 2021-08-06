import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class SmartRadioGroup<T> extends SmartFormField<T?> {
  /// The name of the radio group this radio button belongs to.
  final String group;

  const SmartRadioGroup({
    Key? key,
    required this.group,
    T? initialValue,
    List<Validation<T>>? validators,
  }) : super(
          key: key,
          name: group,
          initialValue: initialValue,
          enabled: true,
          validators: validators ?? const [],
        );

  @override
  Widget buildForm(
      BuildContext context, T? value, String? error, bool enabled, SmartFormController smartFormController) {
    return Container();
  }
}