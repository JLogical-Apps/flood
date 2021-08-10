import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Styles for the bool fields.
enum SmartBoolFieldStyle {
  checkbox,
  $switch,
}

/// Bool field for a SmartForm.
class SmartBoolField extends SmartFormField<bool> {
  /// The widget to display after the checkbox/switch.
  final Widget child;

  /// The style of the field.
  final SmartBoolFieldStyle style;

  const SmartBoolField({
    Key? key,
    required String name,
    required this.child,
    bool initiallyChecked: false,
    List<Validation<bool>>? validators,
    this.style: SmartBoolFieldStyle.checkbox,
    bool enabled: true,
  }) : super(
          key: key,
          name: name,
          initialValue: initiallyChecked,
          validators: validators ?? const [],
          enabled: enabled,
        );

  @override
  Widget buildForm(
      BuildContext context, bool value, String? error, bool enabled, SmartFormController smartFormController) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => smartFormController.setData(name: name, value: !value),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                style == SmartBoolFieldStyle.checkbox
                    ? Checkbox(
                        value: value,
                        onChanged: !enabled
                            ? null
                            : (value) {
                                smartFormController.setData(name: name, value: value);
                              },
                        fillColor:
                            MaterialStateProperty.all(error == null ? Theme.of(context).accentColor : Colors.red),
                      )
                    : Switch(
                        value: value,
                        onChanged: !enabled
                            ? null
                            : (value) {
                                smartFormController.setData(name: name, value: value);
                              },
                      ),
                child,
              ],
            ),
          ),
        ),
        if (error != null)
          Text(
            error,
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
