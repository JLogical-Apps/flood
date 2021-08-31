import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Styled SmartOptionsField that uses a [StyledDropdown].
class StyledSmartOptionsField<T> extends SmartFormField<T?> {
  /// The options to choose from.
  final List<T> options;

  /// Builder for an option to a widget.
  /// Also must handle the null option if no selection.
  /// Defaults to a Text with the value.toString().
  final Widget Function(T?)? builder;

  /// An optional label for the field.
  final String? label;

  /// Whether a "None" field is shown.
  /// If [canBeNone] is false and [initialValue] is null,
  /// shows a "Select..." field.
  final bool canBeNone;

  const StyledSmartOptionsField({
    Key? key,
    required String name,
    required this.options,
    T? initialValue,
    this.builder,
    this.label,
    this.canBeNone: false,
    bool enabled: true,
    List<Validation<T?>>? validators,
  }) : super(
          key: key,
          name: name,
          initialValue: initialValue,
          validators: validators ?? const [],
          enabled: enabled,
        );

  @override
  Widget buildForm(
    BuildContext context,
    T? value,
    String? error,
    bool enabled,
    SmartFormController smartFormController,
  ) {
    return StyledDropdown<T>(
      value: value,
      onChanged: (value) => smartFormController.setData(name: name, value: value),
      label: label,
      errorText: error,
      options: options,
      canBeNone: canBeNone,
      builder: builder,
    );
  }
}
