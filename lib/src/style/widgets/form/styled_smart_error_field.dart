import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_error_text.dart';

import '../../../form/export.dart';

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
