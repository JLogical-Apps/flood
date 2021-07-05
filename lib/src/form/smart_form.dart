import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/smartform/smart_form.dart';
import 'package:provider/provider.dart';

import 'smart_form_controller.dart';

/// Simplifies the process of creating forms.
/// Simply give a [controller] and place some [SmartFormField]s as children to get things up and running.
class SmartForm extends StatelessWidget {
  /// The controller that controls this form.
  final SmartFormController controller;

  /// Validator to use after all other fields have been checked.
  final PostValidator? postValidator;

  final Widget child;

  const SmartForm({Key? key, required this.controller, required this.child, this.postValidator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.postValidator = postValidator;

    return Provider.value(
      value: controller,
      child: child,
    );
  }
}
