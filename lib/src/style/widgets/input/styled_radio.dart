import 'package:flutter/material.dart';

import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';

class StyledRadio<T> extends StyledWidget {
  final String? labelText;

  final Widget? label;

  /// The value of the group this radio is in.
  final T groupValue;

  /// The value of this radio.
  final T radioValue;

  /// If not null, then the error associated with this radio.
  final String? errorText;

  /// Action to perform when the value is changed.
  final void Function(T value)? onChanged;

  StyledRadio({
    super.key,
    this.labelText,
    this.label,
    required this.groupValue,
    required this.radioValue,
    this.errorText,
    this.onChanged,
  });

  bool get hasError => errorText != null;

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.radio(context, styleContext, this);
  }
}
