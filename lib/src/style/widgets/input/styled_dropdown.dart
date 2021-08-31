import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Dropdown that contains a [value] and renders the available options using [builder] or a default.
class StyledDropdown<T> extends StyledWidget {
  final String? label;

  /// The value of the dropdown.
  final T? value;

  /// Builder for the options. If null, a default builder is used.
  final Widget Function(T? value)? builder;

  /// The options that can be chosen from.
  final List<T> options;

  /// Whether [null] can be chosen as an option.
  final bool canBeNone;

  /// If not null, then the error associated with this dropdown.
  final String? errorText;

  /// Action to perform when the value is changed.
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
