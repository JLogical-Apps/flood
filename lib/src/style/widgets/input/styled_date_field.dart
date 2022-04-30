import 'package:flutter/material.dart';

import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';

class StyledDateField extends StyledWidget {
  final String? label;
  final Widget? leading;
  final Widget? trailing;

  /// The value of the date field.
  final DateTime? date;

  /// If not null, then the error associated with this date field.
  final String? errorText;

  /// Action to perform when the date is changed.
  final void Function(DateTime value)? onChanged;

  StyledDateField({
    this.label,
    this.leading,
    this.trailing,
    this.date,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.dateField(context, styleContext, this);
  }
}
