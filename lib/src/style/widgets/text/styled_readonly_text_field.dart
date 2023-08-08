import 'package:flutter/widgets.dart';

import '../input/styled_text_field.dart';

class StyledReadonlyTextField extends StatelessWidget {
  final Widget? label;
  final String? labelText;

  final String? text;
  final String? errorText;

  final Widget? leading;
  final Widget? trailing;

  final int maxLines;

  StyledReadonlyTextField(
    this.text, {
    this.label,
    this.labelText,
    this.errorText,
    this.maxLines: 1,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return StyledTextField(
      key: UniqueKey(),
      initialText: text,
      label: label,
      labelText: labelText,
      maxLines: maxLines,
      errorText: errorText,
      leading: leading,
      trailing: trailing,
      enabled: false,
    );
  }
}
