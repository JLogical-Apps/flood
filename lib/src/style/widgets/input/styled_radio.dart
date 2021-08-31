import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledRadio<T> extends StyledWidget {
  /// The value of the group this radio is in.
  final T groupValue;

  /// The value of this radio.
  final T radioValue;

  final String? label;

  /// If not null, then the error associated with this radio.
  final String? errorText;

  /// Action to perform when the value is changed.
  final void Function(T value)? onChanged;

  StyledRadio({
    required this.groupValue,
    required this.radioValue,
    this.label,
    this.errorText,
    this.onChanged,
  });

  bool get hasError => errorText != null;

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.radio(context, styleContext, this);
  }
}
