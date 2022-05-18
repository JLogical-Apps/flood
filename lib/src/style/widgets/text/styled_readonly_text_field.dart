import 'package:flutter/widgets.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledReadonlyTextField extends StatelessWidget {
  final Widget? label;
  final String? labelText;

  final String text;

  final int maxLines;

  StyledReadonlyTextField(this.text, {this.label, this.labelText, this.maxLines: 1});

  @override
  Widget build(BuildContext context) {
    return StyledTextField(
      key: UniqueKey(),
      initialText: text,
      label: label,
      labelText: labelText,
      maxLines: maxLines,
      enabled: false,
    );
  }
}