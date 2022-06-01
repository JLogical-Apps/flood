import 'package:flutter/widgets.dart';

import '../input/styled_text_field.dart';

class StyledReadonlyTextField extends StatelessWidget {
  final Widget? label;
  final String? labelText;

  final String? text;
  final String? errorText;

  final int maxLines;

  StyledReadonlyTextField(this.text, {this.label, this.labelText, this.errorText, this.maxLines: 1});

  @override
  Widget build(BuildContext context) {
    return StyledTextField(
      key: UniqueKey(),
      initialText: text,
      label: label,
      labelText: labelText,
      maxLines: maxLines,
      errorText: errorText,
      enabled: false,
    );
  }
}
