import 'package:flutter/material.dart';

import '../../../../jlogical_utils.dart';

/// Styled SmartErrorField that uses a [StyledErrorText].
class StyledSmartErrorField extends SmartFormField {
  const StyledSmartErrorField({
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
    return error == null ? SizedBox.shrink() : StyledErrorText(error);
  }
}
