import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledRadio<T> extends StyledWidget {
  final T groupValue;
  final T radioValue;

  final String? label;

  final String? errorText;

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
