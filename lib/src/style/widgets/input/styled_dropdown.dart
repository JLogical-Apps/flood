import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledDropdown<T> extends StyledWidget {
  final String? label;
  final T? value;

  final Widget Function(T?)? builder;

  final List<T> options;
  final bool canBeNone;

  final String? errorText;

  final void Function(T? value)? onChanged;

  StyledDropdown({
    this.label,
    this.value,
    this.builder,
    this.options: const [],
    this.canBeNone: false,
    this.errorText,
    this.onChanged,
  });

  bool get hasError => errorText != null;

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.dropdown(context, styleContext, this);
  }
}
