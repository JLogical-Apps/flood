import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledDateField extends StyledWidget {
  final String? label;
  final Widget? leading;
  final Widget? trailing;

  final DateTime? initialDate;
  final String? errorText;

  final bool enabled;

  final void Function(DateTime value)? onChanged;

  StyledDateField({
    this.label,
    this.leading,
    this.trailing,
    this.initialDate,
    this.errorText,
    this.enabled: true,
    this.onChanged,
  });

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.dateField(context, styleContext, this);
  }
}
