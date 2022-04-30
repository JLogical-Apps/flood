import 'package:flutter/material.dart';

import '../smart_form_controller.dart';
import '../smart_form_field.dart';

/// Only shows up when an error is present with its name.
class SmartErrorField extends SmartFormField {
  const SmartErrorField({
    Key? key,
    required String name,
  }) : super(
          key: key,
          name: name,
          initialValue: null,
          validators: const [],
        );

  @override
  Widget buildForm(
      BuildContext context, dynamic value, String? error, bool enabled, SmartFormController smartFormController) {
    if (error == null) {
      return SizedBox.shrink();
    } else {
      return Text(
        error,
        style: TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      );
    }
  }
}
